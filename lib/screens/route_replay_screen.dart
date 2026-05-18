import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class RouteReplayScreen extends StatefulWidget {
  final TripRecord trip;

  const RouteReplayScreen({super.key, required this.trip});

  @override
  State<RouteReplayScreen> createState() => _RouteReplayScreenState();
}

class _RouteReplayScreenState extends State<RouteReplayScreen> {
  final _api = ApiService();
  final _mapController = MapController();

  List<RoutePoint> _points = [];
  bool _loading = true;
  bool _playing = false;
  int _currentIndex = 0;
  Timer? _timer;
  double _speed = 1.0;

  List<LatLng> get _latlngs =>
      _points.map((p) => LatLng(p.lat, p.lng)).toList();

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final points = await _api.getRoutePoints(widget.trip.id);
      if (!mounted) return;
      setState(() {
        _points = points;
        _loading = false;
      });
      if (points.isNotEmpty) {
        final first = points.first;
        _mapController.move(LatLng(first.lat, first.lng), 14);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(e is ApiException ? e.message : 'Failed to load route'),
        backgroundColor: AppColors.red,
      ));
    }
  }

  void _togglePlay() {
    if (_playing) {
      _timer?.cancel();
      setState(() => _playing = false);
    } else {
      if (_currentIndex >= _points.length - 1) {
        setState(() => _currentIndex = 0);
      }
      setState(() => _playing = true);
      _timer = Timer.periodic(
        Duration(milliseconds: (100 / _speed).round()),
        (_) => _advance(),
      );
    }
  }

  void _advance() {
    if (_currentIndex >= _points.length - 1) {
      _timer?.cancel();
      setState(() => _playing = false);
      return;
    }
    setState(() => _currentIndex++);
    final p = _points[_currentIndex];
    _mapController.move(LatLng(p.lat, p.lng), 14);
  }

  void _setSpeed(double s) {
    _speed = s;
    if (_playing) {
      _timer?.cancel();
      _timer = Timer.periodic(
        Duration(milliseconds: (100 / s).round()),
        (_) => _advance(),
      );
    }
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final current =
        _currentIndex < _points.length ? _points[_currentIndex] : null;

    return Scaffold(
      backgroundColor: AppColors.navy,
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.teal))
          : Column(
              children: [
                SizedBox(height: topPad),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Row(
                          children: [
                            const Icon(Icons.arrow_back_ios_rounded,
                                color: AppColors.teal, size: 18),
                            const SizedBox(width: 4),
                            Text('Back',
                                style: AppText.dm(
                                    size: 13, color: AppColors.teal)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text('Route Replay',
                            style: AppText.syne(size: 18)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      FlutterMap(
                        options: MapOptions(
                          initialCenter: _latlngs.isNotEmpty
                              ? _latlngs.first
                              : const LatLng(-13.9833, 33.7833),
                          initialZoom: 14,
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
                          if (_points.length > 1)
                            PolylineLayer(polylines: [
                              Polyline(
                                points: _latlngs,
                                color: AppColors.teal.withValues(alpha: 0.6),
                                strokeWidth: 3,
                              ),
                            ]),
                          if (current != null)
                            MarkerLayer(markers: [
                              Marker(
                                point: LatLng(current.lat, current.lng),
                                width: 24,
                                height: 24,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.teal,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 2.5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.teal
                                            .withValues(alpha: 0.5),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                        ],
                      ),
                      Positioned(
                        left: 10,
                        right: 10,
                        bottom: 10,
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.navy.withValues(alpha: 0.96),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_points.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Container(
                                    height: 4,
                                    color: AppColors.border,
                                    child: LayoutBuilder(
                                      builder: (ctx, constraints) {
                                        final fraction = _currentIndex /
                                            (_points.length - 1);
                                        return Row(children: [
                                          Container(
                                            width: constraints.maxWidth *
                                                fraction,
                                            color: AppColors.teal,
                                          ),
                                        ]);
                                      },
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => _setSpeed(1),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _speed == 1
                                            ? AppColors.teal
                                                .withValues(alpha: 0.15)
                                            : Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(6),
                                      ),
                                      child: Text('1×',
                                          style: AppText.dm(
                                              size: 11,
                                              color: _speed == 1
                                                  ? AppColors.teal
                                                  : AppColors.muted,
                                              weight: FontWeight.w600)),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: () => _setSpeed(2),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _speed == 2
                                            ? AppColors.teal
                                                .withValues(alpha: 0.15)
                                            : Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(6),
                                      ),
                                      child: Text('2×',
                                          style: AppText.dm(
                                              size: 11,
                                              color: _speed == 2
                                                  ? AppColors.teal
                                                  : AppColors.muted,
                                              weight: FontWeight.w600)),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: () => _setSpeed(4),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _speed == 4
                                            ? AppColors.teal
                                                .withValues(alpha: 0.15)
                                            : Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(6),
                                      ),
                                      child: Text('4×',
                                          style: AppText.dm(
                                              size: 11,
                                              color: _speed == 4
                                                  ? AppColors.teal
                                                  : AppColors.muted,
                                              weight: FontWeight.w600)),
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: _togglePlay,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.teal
                                            .withValues(alpha: 0.12),
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        _playing
                                            ? Icons.pause_rounded
                                            : Icons.play_arrow_rounded,
                                        size: 20,
                                        color: AppColors.teal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _points.isNotEmpty
                                    ? '${_currentIndex + 1} / ${_points.length} points'
                                    : 'No route data',
                                style: AppText.dm(
                                    size: 11, color: AppColors.muted),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
