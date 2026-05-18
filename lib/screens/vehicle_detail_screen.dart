import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import 'package:fleet_track/screens/route_replay_screen.dart';

class VehicleDetailScreen extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleDetailScreen({super.key, required this.vehicle});

  Future<void> _openInMaps(BuildContext context) async {
    final lat = vehicle.lat;
    final lng = vehicle.lng;
    if (lat == null || lng == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('No coordinates available for this vehicle'),
        backgroundColor: AppColors.red,
      ));
      return;
    }
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Could not open maps'),
        backgroundColor: AppColors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Column(
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
                      Text('Fleet',
                          style: AppText.dm(size: 13, color: AppColors.teal)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vehicle.name, style: AppText.syne(size: 17)),
                      Text(vehicle.plate, style: AppText.mono(size: 11)),
                    ],
                  ),
                ),
                StatusTag(status: vehicle.status),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 40),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SizedBox(
                      height: 110,
                      child: Stack(
                        children: [
                          Container(color: const Color(0xFF0E1E38)),
                          CustomPaint(
                              size: const Size(double.infinity, 110),
                              painter: GridPainter()),
                          Positioned(
                              top: 60,
                              left: 0,
                              right: 0,
                              child: Container(
                                  height: 5,
                                  color:
                                      AppColors.blue.withValues(alpha: 0.15))),
                          Positioned(
                              left: 45,
                              top: 0,
                              bottom: 0,
                              child: Container(
                                  width: 5,
                                  color:
                                      AppColors.blue.withValues(alpha: 0.15))),
                          Positioned(
                              top: 48,
                              left: 38,
                              child: Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                      color: AppColors.teal,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: AppColors.teal2, width: 2),
                                      boxShadow: [
                                        BoxShadow(
                                            color: AppColors.teal
                                                .withValues(alpha: 0.2),
                                            blurRadius: 4,
                                            spreadRadius: 4)
                                      ]),
                                  alignment: Alignment.center,
                                  child: const Text('▶',
                                      style: TextStyle(
                                          fontSize: 7,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black)))),
                          Positioned(
                            top: 33,
                            left: 48,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                  color: AppColors.navy.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color: AppColors.teal
                                          .withValues(alpha: 0.3))),
                              child: Text('${vehicle.speed.toInt()} km/h',
                                  style: AppText.mono(
                                      size: 9, color: AppColors.teal)),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => _openInMaps(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    color: AppColors.navy.withValues(alpha: 0.9),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: AppColors.border)),
                                child: Text('Open in Maps ↗',
                                    style: AppText.dm(
                                        size: 11, color: AppColors.teal)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.navy2,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Current speed',
                                    style: AppText.dm(
                                        size: 11, color: AppColors.muted)),
                                const SizedBox(height: 3),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text('${vehicle.speed.toInt()}',
                                        style: AppText.syne(
                                            size: 34,
                                            color: AppColors.teal,
                                            weight: FontWeight.w800)),
                                    const SizedBox(width: 4),
                                    Text('km/h',
                                        style: AppText.dm(
                                            size: 12, color: AppColors.muted)),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Max today',
                                    style: AppText.dm(
                                        size: 11, color: AppColors.muted)),
                                const SizedBox(height: 3),
                                Text('87 km/h',
                                    style: AppText.syne(
                                        size: 16, color: AppColors.amber)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: const LinearProgressIndicator(
                            value: 0.52,
                            backgroundColor: AppColors.navy3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.teal),
                            minHeight: 4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('0',
                                style: AppText.mono(
                                    size: 11, color: AppColors.muted)),
                            Text('Limit: 80',
                                style: AppText.dm(
                                    size: 11,
                                    color: AppColors.amber,
                                    weight: FontWeight.w600)),
                            Text('120',
                                style: AppText.mono(
                                    size: 11, color: AppColors.muted)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                          child: _MiniStatCard(
                              label: 'Odometer',
                              value: '${vehicle.mileage}',
                              unit: 'km total')),
                      const SizedBox(width: 8),
                      const Expanded(
                          child: _MiniStatCard(
                              label: 'Today dist.',
                              value: '142',
                              unit: 'km today',
                              color: AppColors.teal)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Expanded(
                          child: _MiniStatCard(
                              label: 'Engine',
                              value: 'ON',
                              unit: 'since 07:14',
                              color: AppColors.teal)),
                      SizedBox(width: 8),
                      Expanded(
                          child: _MiniStatCard(
                              label: 'Heading', value: 'NE', unit: '42°')),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.navy2,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_rounded,
                            size: 22, color: AppColors.teal),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(vehicle.location,
                                  style: AppText.dm(
                                      size: 13, weight: FontWeight.w600)),
                              const SizedBox(height: 3),
                              Text('${vehicle.mileage} km total',
                                  style: AppText.mono(
                                      size: 11, color: AppColors.muted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                          child: _ActionBtn(
                        icon: Icons.history_rounded,
                        label: 'Trip History',
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    TripHistoryScreen(vehicle: vehicle))),
                      )),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Expanded(
                          child: _ActionBtn(
                              icon: Icons.fence_rounded,
                              label: 'Geofences',
                              color: AppColors.amber)),
                      SizedBox(width: 8),
                      Expanded(
                          child: _ActionBtn(
                              icon: Icons.edit_rounded,
                              label: 'Edit Vehicle',
                              color: AppColors.blue)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const SectionHeader(label: 'Recent Activity'),
                  const _TimelineItem(
                      title: 'Speed alert — 89 km/h',
                      time: '09:15',
                      color: AppColors.amber),
                  const _TimelineItem(
                      title: 'Entered Geofence: Mzuzu',
                      time: '08:50',
                      color: AppColors.teal,
                      isLast: false),
                  const _TimelineItem(
                      title: 'Trip started',
                      time: '07:14',
                      color: AppColors.blue,
                      isLast: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final String label, value, unit;
  final Color? color;

  const _MiniStatCard(
      {required this.label,
      required this.value,
      required this.unit,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.navy2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppText.dm(size: 11, color: AppColors.muted)),
          const SizedBox(height: 4),
          Text(value,
              style: AppText.syne(
                  size: 17,
                  color: color ?? AppColors.text,
                  weight: FontWeight.w800)),
          Text(unit, style: AppText.dm(size: 11, color: AppColors.muted)),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _ActionBtn(
      {required this.icon,
      required this.label,
      this.color = AppColors.teal,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(label,
                style: AppText.dm(
                    size: 12, color: color, weight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String title, time;
  final Color color;
  final bool isLast;

  const _TimelineItem(
      {required this.title,
      required this.time,
      required this.color,
      this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
                width: 9,
                height: 9,
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle)),
            if (!isLast)
              Container(width: 1, height: 30, color: AppColors.border),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppText.dm(size: 13, weight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(time, style: AppText.mono(size: 11)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TripHistoryScreen extends StatefulWidget {
  final Vehicle vehicle;

  const TripHistoryScreen({super.key, required this.vehicle});

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  final _api = ApiService();
  List<TripRecord> _trips = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final trips = await _api.getTrips(vehicleId: widget.vehicle.id);
      if (!mounted) return;
      setState(() {
        _trips = trips;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e is ApiException ? e.message : 'Failed to load trips'),
        backgroundColor: AppColors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.teal))
          : Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
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
                      Text('Fleet',
                          style: AppText.dm(size: 13, color: AppColors.teal)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                    child: Text('Trip History', style: AppText.syne(size: 18))),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.navy2,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.calendar_month_rounded,
                      size: 20, color: AppColors.muted),
                ),
              ],
            ),
          ),
          Expanded(
            child: _trips.isEmpty
                ? Center(
                    child: Text('No trips found',
                        style: AppText.dm(size: 13, color: AppColors.muted)))
                : ListView(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 40),
              children: [
                const _DateLabel('Today'),
                ..._trips.map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _TripCard(
                    trip: t,
                    tagText: t.isActive ? '\u25B6 Active' : '\u25A0 Complete',
                    tagColor: t.isActive ? AppColors.teal : AppColors.muted,
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateLabel extends StatelessWidget {
  final String text;
  const _DateLabel(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text.toUpperCase(),
          style: AppText.dm(
              size: 11, color: AppColors.muted, weight: FontWeight.w600)),
    );
  }
}

class _TripCard extends StatelessWidget {
  final TripRecord trip;
  final String tagText;
  final Color tagColor;

  const _TripCard(
      {required this.trip, required this.tagText, required this.tagColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.navy2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(trip.id == 't1' ? 'Trip #1' : 'Trip #3',
                      style: AppText.syne(size: 14)),
                  Text('${trip.startTime} — ${trip.endTime}',
                      style: AppText.mono(size: 11)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: tagColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: tagColor.withValues(alpha: 0.25)),
                ),
                child: Text(tagText,
                    style: AppText.dm(
                        size: 10, color: tagColor, weight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
                child: _TripStat(
                    value: trip.distanceKm.toInt().toString(),
                    unit: 'km',
                    color: AppColors.teal)),
            const SizedBox(width: 6),
            Expanded(
                child: _TripStat(
                    value:
                        '${trip.durationHrs.floor()}:${((trip.durationHrs % 1) * 60).toInt().toString().padLeft(2, '0')}',
                    unit: 'hrs')),
            const SizedBox(width: 6),
            Expanded(
                child: _TripStat(
                    value: trip.avgSpeed.toInt().toString(), unit: 'avg km/h')),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                    color: AppColors.teal, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(trip.origin,
                style: AppText.dm(size: 12, color: AppColors.text2)),
          ]),
          Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Container(width: 2, height: 14, color: AppColors.border),
          ),
          Row(children: [
            Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.teal, width: 2))),
            const SizedBox(width: 8),
            Text(trip.destination,
                style: AppText.dm(size: 12, color: AppColors.text2)),
          ]),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RouteReplayScreen(trip: trip),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.teal.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_circle_outline_rounded,
                      size: 14, color: AppColors.teal),
                  const SizedBox(width: 6),
                  Text('Replay Route',
                      style: AppText.dm(
                          size: 12, color: AppColors.teal, weight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TripStat extends StatelessWidget {
  final String value, unit;
  final Color color;
  const _TripStat(
      {required this.value, required this.unit, this.color = AppColors.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: AppColors.navy3, borderRadius: BorderRadius.circular(8)),
      child: Column(children: [
        Text(value, style: AppText.syne(size: 15, color: color)),
        Text(unit, style: AppText.dm(size: 11, color: AppColors.muted)),
      ]),
    );
  }
}


