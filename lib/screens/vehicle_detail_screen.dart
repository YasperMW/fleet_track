import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/shared_widgets.dart';

// ═══════════════════════════════════════════════════════════
// VEHICLE DETAIL SCREEN
// ═══════════════════════════════════════════════════════════
class VehicleDetailScreen extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleDetailScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Column(
        children: [
          SizedBox(height: topPad),
          // Header
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
                      Text(vehicle.plate,
                          style: AppText.mono(size: 11)),
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
                  // Mini map
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: MapMock(height: 120),
                  ),
                  const SizedBox(height: 12),

                  // Location card
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
                            color: AppColors.teal, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(vehicle.location,
                              style: AppText.dm(size: 13)),
                        ),
                        Text('GPS · Good',
                            style: AppText.dm(
                                size: 11, color: AppColors.teal)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Stats row
                  Row(
                    children: [
                      Expanded(
                        child: _DetailStat(
                          label: 'Speed',
                          value: '${vehicle.speed.toInt()}',
                          unit: 'km/h',
                          color: vehicle.speed > 0
                              ? AppColors.teal
                              : AppColors.muted,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _DetailStat(
                          label: 'Mileage',
                          value: '${vehicle.mileage ~/ 1000},${vehicle.mileage % 1000}',
                          unit: 'km total',
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: _DetailStat(
                          label: 'Signal',
                          value: '4G',
                          unit: 'connected',
                          color: AppColors.teal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Device info
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.navy2,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _InfoRow(label: 'Device ID', value: 'FT-00124'),
                        const Divider(color: AppColors.border, height: 16),
                        _InfoRow(label: 'Last seen', value: '09:41:22'),
                        const Divider(color: AppColors.border, height: 16),
                        _InfoRow(
                            label: 'Coordinates',
                            value: '-13.9626, 33.7741'),
                        const Divider(color: AppColors.border, height: 16),
                        _InfoRow(label: 'Driver', value: 'John Banda'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Battery / fuel
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('GPS Battery',
                                style: AppText.dm(size: 13)),
                            Text('72%',
                                style: AppText.dm(
                                    size: 13, color: AppColors.teal)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.navy3,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: 0.72,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppColors.teal, AppColors.blue],
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: _ActionBtn(
                          icon: Icons.history_rounded,
                          label: 'Trip History',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => TripHistoryScreen(
                                    vehicle: vehicle)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ActionBtn(
                          icon: Icons.replay_rounded,
                          label: 'Route Replay',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => RouteReplayScreen(
                                    vehicle: vehicle)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionBtn(
                          icon: Icons.fence_rounded,
                          label: 'Geofences',
                          color: AppColors.amber,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ActionBtn(
                          icon: Icons.edit_rounded,
                          label: 'Edit Vehicle',
                          color: AppColors.blue,
                        ),
                      ),
                    ],
                  ),

                  // Timeline
                  const SizedBox(height: 20),
                  SectionHeader(label: 'Recent Activity'),
                  _TimelineItem(
                    title: 'Speed alert — 89 km/h',
                    time: '09:15',
                    color: AppColors.amber,
                  ),
                  _TimelineItem(
                    title: 'Entered Geofence: Mzuzu',
                    time: '08:50',
                    color: AppColors.teal,
                    isLast: false,
                  ),
                  _TimelineItem(
                    title: 'Trip started',
                    time: '07:14',
                    color: AppColors.blue,
                    isLast: true,
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

class _DetailStat extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _DetailStat({
    required this.label,
    required this.value,
    required this.unit,
    this.color = AppColors.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.navy2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(label,
              style: AppText.dm(size: 11, color: AppColors.muted)),
          const SizedBox(height: 4),
          Text(value, style: AppText.syne(size: 18, color: color)),
          Text(unit,
              style: AppText.dm(size: 10, color: AppColors.muted)),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppText.dm(size: 12, color: AppColors.muted)),
        Text(value,
            style: label == 'Coordinates' || label == 'Device ID' || label == 'Last seen'
                ? AppText.mono(size: 11, color: AppColors.text2)
                : AppText.dm(size: 12, color: AppColors.text2)),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _ActionBtn({
    required this.icon,
    required this.label,
    this.color = AppColors.teal,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(label,
                style: AppText.dm(size: 12, color: color,
                    weight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String title;
  final String time;
  final Color color;
  final bool isLast;

  const _TimelineItem({
    required this.title,
    required this.time,
    required this.color,
    this.isLast = false,
  });

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
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            if (!isLast)
              Container(
                  width: 1,
                  height: 30,
                  color: AppColors.border),
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

// ═══════════════════════════════════════════════════════════
// TRIP HISTORY SCREEN
// ═══════════════════════════════════════════════════════════
class TripHistoryScreen extends StatelessWidget {
  final Vehicle vehicle;

  const TripHistoryScreen({super.key, required this.vehicle});

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
                  child: Text('Trip History', style: AppText.syne(size: 18)),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
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
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 40),
              children: [
                _DateLabel('Today — 15 May 2026'),
                _TripCard(trip: SampleData.trips[0]),
                const SizedBox(height: 14),
                _DateLabel('Yesterday — 14 May'),
                _TripCard(trip: SampleData.trips[1]),
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
      child: Text(
        text.toUpperCase(),
        style: AppText.dm(size: 11, color: AppColors.muted, weight: FontWeight.w600)
            .copyWith(letterSpacing: 0.5),
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final TripRecord trip;

  const _TripCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
              trip.isActive
                  ? StatusTag(status: VehicleStatus.moving)
                  : StatusTag(status: VehicleStatus.parked),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
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
                      value: trip.avgSpeed.toInt().toString(),
                      unit: 'avg km/h')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                    color: AppColors.teal, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(trip.origin,
                  style: AppText.dm(size: 12, color: AppColors.text2)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Container(
                width: 2, height: 14, color: AppColors.border),
          ),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: AppColors.teal, width: 2),
                ),
              ),
              const SizedBox(width: 8),
              Text(trip.destination,
                  style: AppText.dm(size: 12, color: AppColors.text2)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TripStat extends StatelessWidget {
  final String value;
  final String unit;
  final Color color;

  const _TripStat(
      {required this.value,
      required this.unit,
      this.color = AppColors.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.navy3,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(value, style: AppText.syne(size: 15, color: color)),
          Text(unit,
              style: AppText.dm(size: 11, color: AppColors.muted)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// ROUTE REPLAY SCREEN
// ═══════════════════════════════════════════════════════════
class RouteReplayScreen extends StatefulWidget {
  final Vehicle vehicle;

  const RouteReplayScreen({super.key, required this.vehicle});

  @override
  State<RouteReplayScreen> createState() => _RouteReplayScreenState();
}

class _RouteReplayScreenState extends State<RouteReplayScreen> {
  bool _isPlaying = false;
  double _progress = 0.42;

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Stack(
        children: [
          // Full screen map
          Positioned.fill(
            child: Container(
              color: const Color(0xFF0E1E38),
              child: Stack(
                children: [
                  CustomPaint(
                      size: Size.infinite, painter: _GridPainterReplay()),
                  // Roads
                  Positioned(
                    top: size.height * 0.45,
                    left: 0, right: 0,
                    child: Container(height: 5,
                        color: AppColors.blue.withOpacity(0.18)),
                  ),
                  Positioned(
                    top: size.height * 0.65,
                    left: 0, right: 0,
                    child: Container(height: 8,
                        color: AppColors.blue.withOpacity(0.25)),
                  ),
                  Positioned(
                    left: size.width * 0.3,
                    top: 0, bottom: 0,
                    child: Container(width: 5,
                        color: AppColors.blue.withOpacity(0.18)),
                  ),
                  Positioned(
                    left: size.width * 0.6,
                    top: 0, bottom: 0,
                    child: Container(width: 8,
                        color: AppColors.blue.withOpacity(0.25)),
                  ),
                  // Route path SVG-like
                  CustomPaint(
                    size: Size.infinite,
                    painter: _RoutePainter(progress: _progress),
                  ),
                  // Vehicle position
                  Positioned(
                    top: size.height * 0.38,
                    left: size.width * 0.48,
                    child: Container(
                      width: 26, height: 26,
                      decoration: BoxDecoration(
                        color: AppColors.teal,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.teal.withOpacity(0.4),
                            blurRadius: 12, spreadRadius: 3)
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Text('▶',
                          style: TextStyle(fontSize: 9, color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Status bar
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              color: AppColors.navy.withOpacity(0.8),
              padding: EdgeInsets.only(top: topPad),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_back_ios_rounded,
                              color: AppColors.teal, size: 18),
                          Text('Detail',
                              style: AppText.dm(
                                  size: 13, color: AppColors.teal)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('Route Replay',
                        style: AppText.syne(size: 18)),
                  ],
                ),
              ),
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 20, left: 14, right: 14,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.navy.withOpacity(0.95),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Trip #1',
                          style: AppText.syne(size: 14)),
                      Text('07:14 — 09:41',
                          style: AppText.mono(size: 11)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Slider
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.teal,
                      inactiveTrackColor: AppColors.navy3,
                      thumbColor: AppColors.teal,
                      thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 8),
                      trackHeight: 3,
                      overlayShape: SliderComponentShape.noOverlay,
                    ),
                    child: Slider(
                      value: _progress,
                      onChanged: (v) => setState(() => _progress = v),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('07:14', style: AppText.mono(size: 10)),
                      Text('09:41', style: AppText.mono(size: 10)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ReplayBtn(
                        icon: Icons.skip_previous_rounded,
                        onTap: () => setState(() => _progress = 0),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () => setState(() => _isPlaying = !_isPlaying),
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.teal, AppColors.blue],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.black, size: 28),
                        ),
                      ),
                      const SizedBox(width: 16),
                      _ReplayBtn(
                        icon: Icons.skip_next_rounded,
                        onTap: () =>
                            setState(() => _progress = 1.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _ReplayStat(label: 'Speed', value: '62 km/h'),
                      _ReplayStat(label: 'Distance', value: '59 km'),
                      _ReplayStat(label: 'Time', value: '08:02'),
                    ],
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

class _ReplayBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ReplayBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          color: AppColors.navy2,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, color: AppColors.text, size: 22),
      ),
    );
  }
}

class _ReplayStat extends StatelessWidget {
  final String label;
  final String value;

  const _ReplayStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppText.dm(size: 13, weight: FontWeight.w600)),
        Text(label, style: AppText.dm(size: 11, color: AppColors.muted)),
      ],
    );
  }
}

class _GridPainterReplay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.blue.withOpacity(0.05)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 22) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 22) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _RoutePainter extends CustomPainter {
  final double progress;

  _RoutePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.1, size.height * 0.7)
      ..lineTo(size.width * 0.22, size.height * 0.7)
      ..lineTo(size.width * 0.3, size.height * 0.65)
      ..lineTo(size.width * 0.42, size.height * 0.65)
      ..lineTo(size.width * 0.5, size.height * 0.58)
      ..lineTo(size.width * 0.58, size.height * 0.55)
      ..lineTo(size.width * 0.68, size.height * 0.5)
      ..lineTo(size.width * 0.75, size.height * 0.48);

    final paint = Paint()
      ..color = AppColors.teal.withOpacity(0.8)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, paint);

    // Start dot
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.7),
      6,
      Paint()..color = AppColors.teal,
    );
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.7),
      6,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_RoutePainter old) => old.progress != progress;
}
