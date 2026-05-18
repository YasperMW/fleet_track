import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import 'vehicle_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _api = ApiService();
  final _searchController = TextEditingController();
  final _mapController = MapController();

  List<Vehicle> _vehicles = [];
  List<AlertItem> _alerts = [];
  bool _loading = true;
  LatLng? _myLocation;
  bool _recording = false;
  String? _recordingTripId;
  Timer? _recordingTimer;
  int _recordingPointCount = 0;

  static const _initialCenter = LatLng(-13.9833, 33.7833);
  static const _initialZoom = 11.0;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _requestLocation();
    _searchController.addListener(() => setState(() {}));
  }

  Future<void> _requestLocation() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final requested = await Geolocator.requestPermission();
      if (requested == LocationPermission.denied ||
          requested == LocationPermission.deniedForever) {
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      if (!mounted) return;
      setState(() => _myLocation = LatLng(pos.latitude, pos.longitude));
    } catch (_) {}
  }

  Future<void> _startRecording() async {
    if (_myLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Enable location to record a route'),
        backgroundColor: AppColors.red,
      ));
      return;
    }
    try {
      final trip = await _api.createTrip({
        'vehicle_id': 'v1',
        'origin': 'Current location',
        'is_active': true,
      });
      if (!mounted) return;
      final tripId = trip.id;
      setState(() {
        _recording = true;
        _recordingTripId = tripId;
        _recordingPointCount = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Recording started'),
        backgroundColor: AppColors.teal,
        behavior: SnackBarBehavior.floating,
      ));
      _recordingTimer = Timer.periodic(const Duration(seconds: 5), (_) => _recordPoint());
      _recordPoint();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to start recording'),
        backgroundColor: AppColors.red,
      ));
    }
  }

  Future<void> _recordPoint() async {
    if (_recordingTripId == null) return;
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      if (!mounted) return;
      final point = {'lat': pos.latitude, 'lng': pos.longitude};
      await _api.addRoutePoints(_recordingTripId!, [point]);
      setState(() => _recordingPointCount++);
    } catch (_) {}
  }

  Future<void> _stopRecording() async {
    _recordingTimer?.cancel();
    _recordingTimer = null;
    if (_recordingTripId != null) {
      try {
        await _api.client.patch('/trips/$_recordingTripId/end');
      } catch (_) {}
    }
    if (!mounted) return;
    setState(() {
      _recording = false;
      _recordingTripId = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Recording stopped · $_recordingPointCount points'),
      backgroundColor: AppColors.teal,
      behavior: SnackBarBehavior.floating,
    ));
  }

  Future<void> _fetchData() async {
    try {
      final results = await Future.wait([
        _api.getVehicles(),
        _api.getAlerts(),
      ]);
      if (!mounted) return;
      setState(() {
        _vehicles = results[0] as List<Vehicle>;
        _alerts = results[1] as List<AlertItem>;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(e is ApiException ? e.message : 'Failed to load map data'),
        backgroundColor: AppColors.red,
      ));
    }
  }

  List<Vehicle> get _filtered {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) return _vehicles;
    return _vehicles.where((v) =>
        v.name.toLowerCase().contains(q) ||
        v.plate.toLowerCase().contains(q) ||
        v.location.toLowerCase().contains(q)).toList();
  }

  List<Marker> _buildMarkers() {
    final list = <Marker>[];
    if (_myLocation != null) {
      list.add(Marker(
        point: _myLocation!,
        width: 30,
        height: 30,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Container(
            width: 14,
            height: 14,
            decoration: const BoxDecoration(
              color: Color(0xFF4C8EFF),
              shape: BoxShape.circle,
              border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 2.5)),
            ),
          ),
        ),
      ));
    }
    list.addAll(_filtered.map((v) {
      final lat = v.lat;
      final lng = v.lng;
      if (lat == null || lng == null) return null;
      final color = v.status == VehicleStatus.moving
          ? AppColors.teal
          : v.status == VehicleStatus.alert
              ? AppColors.red
              : AppColors.muted;
      return Marker(
        point: LatLng(lat, lng),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VehicleDetailScreen(vehicle: v),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.navy.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(v.name,
                    style: AppText.dm(size: 9, color: AppColors.text)),
              ),
              const SizedBox(height: 2),
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                        color: color.withValues(alpha: 0.5),
                        blurRadius: 6,
                        spreadRadius: 1),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).whereType<Marker>().toList());
    return list;
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final markers = _buildMarkers();

    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Stack(
        children: [
          if (_loading)
            const Center(
                child: CircularProgressIndicator(color: AppColors.teal))
          else
            FlutterMap(
              options: MapOptions(
                initialCenter: _initialCenter,
                initialZoom: _initialZoom,
                minZoom: 4,
                maxZoom: 18,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
              ),
              mapController: _mapController,
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.fleet_track.app',
                ),
                MarkerLayer(markers: markers),
              ],
            ),
          Positioned(
            top: 84,
            right: 14,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.navy.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: GestureDetector(
                          onTap: () => _mapController.move(
                            _mapController.camera.center,
                            _mapController.camera.zoom + 1,
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: const Text('+',
                                style: TextStyle(
                                    fontSize: 20, color: AppColors.text)),
                          ),
                        ),
                      ),
                      Container(
                          width: 32, height: 1, color: AppColors.border),
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: GestureDetector(
                          onTap: () => _mapController.move(
                            _mapController.camera.center,
                            _mapController.camera.zoom - 1,
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: const Text('\u2212',
                                style: TextStyle(
                                    fontSize: 20, color: AppColors.text)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_myLocation != null) ...[
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.navy.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: SizedBox(
                      width: 44,
                      height: 44,
                      child: GestureDetector(
                        onTap: () => _mapController.move(
                          _myLocation!,
                          15,
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: const Icon(Icons.my_location_rounded,
                              size: 18, color: AppColors.blue),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Positioned(
            top: 56,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.navy.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LegendItem(color: AppColors.teal, label: '\u25B6 Moving'),
                  SizedBox(height: 5),
                  _LegendItem(color: AppColors.muted, label: '\u25A0 Parked'),
                  SizedBox(height: 5),
                  _LegendItem(color: AppColors.red, label: '\u26A0 Alert'),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: AppColors.navy.withValues(alpha: 0.7),
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.navy.withValues(alpha: 0.93),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded,
                              size: 16, color: AppColors.muted),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: AppText.dm(
                                  size: 12, color: AppColors.text),
                              decoration: InputDecoration.collapsed(
                                hintText: 'Search vehicles, locations\u2026',
                                hintStyle: AppText.dm(
                                    size: 12, color: AppColors.muted),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                                color:
                                    AppColors.teal.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: AppColors.teal
                                        .withValues(alpha: 0.25))),
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                          color: AppColors.teal,
                                          shape: BoxShape.circle)),
                                  const SizedBox(width: 4),
                                  Text('Live',
                                      style: AppText.dm(
                                          size: 10,
                                          color: AppColors.teal,
                                          weight: FontWeight.w600)),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 10,
            right: 10,
            bottom: 74,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.navy.withValues(alpha: 0.96),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Fleet Status', style: AppText.syne(size: 14)),
                      Text('Updated 2s ago',
                          style:
                              AppText.dm(size: 11, color: AppColors.muted)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(
                        child: _FleetStat(
                            value:
                                '${_vehicles.where((v) => v.status == VehicleStatus.moving).length}',
                            label: 'Moving',
                            color: AppColors.teal)),
                    Container(
                        width: 1, height: 40, color: AppColors.border),
                    Expanded(
                        child: _FleetStat(
                            value:
                                '${_vehicles.where((v) => v.status == VehicleStatus.parked).length}',
                            label: 'Parked',
                            color: AppColors.text)),
                    Container(
                        width: 1, height: 40, color: AppColors.border),
                    Expanded(
                        child: _FleetStat(
                            value:
                                '${_vehicles.where((v) => v.status == VehicleStatus.alert).length}',
                            label: 'Alert',
                            color: AppColors.red)),
                  ]),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _recording ? _stopRecording : _startRecording,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: _recording
                            ? AppColors.red.withValues(alpha: 0.12)
                            : AppColors.teal.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _recording
                              ? AppColors.red.withValues(alpha: 0.3)
                              : AppColors.teal.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _recording ? AppColors.red : AppColors.teal,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _recording
                                ? 'Stop Recording ($_recordingPointCount)'
                                : 'Record Route',
                            style: AppText.dm(
                              size: 11,
                              color: _recording ? AppColors.red : AppColors.teal,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_alerts.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: AlertBanner(
                          alert: _alerts.first,
                          onTap: () {
                            try {
                              final v = _vehicles.firstWhere(
                                  (v) => v.id == _alerts.first.vehicleId);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        VehicleDetailScreen(vehicle: v)),
                              );
                            } catch (_) {}
                          }),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FleetStat extends StatelessWidget {
  final String value, label;
  final Color color;
  const _FleetStat(
      {required this.value, required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(value,
          style:
              AppText.syne(size: 20, color: color, weight: FontWeight.w800)),
      const SizedBox(height: 2),
      Text(label, style: AppText.dm(size: 11, color: AppColors.muted)),
    ]);
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 6),
      Text(label, style: AppText.dm(size: 10, color: AppColors.text2)),
    ]);
  }
}
