import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/shared_widgets.dart';

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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back_ios_rounded, color: AppColors.teal, size: 18),
                      Text('Fleet', style: AppText.dm(size: 13, color: AppColors.teal)),
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
                          CustomPaint(size: const Size(double.infinity, 110), painter: GridPainter()),
                          Positioned(top: 60, left: 0, right: 0, child: Container(height: 5, color: AppColors.blue.withOpacity(0.15))),
                          Positioned(left: 45, top: 0, bottom: 0, child: Container(width: 5, color: AppColors.blue.withOpacity(0.15))),
                          Positioned(top: 48, left: 38,
                            child: Container(width: 22, height: 22,
                              decoration: BoxDecoration(color: AppColors.teal, shape: BoxShape.circle,
                                border: Border.all(color: AppColors.teal2, width: 2),
                                boxShadow: [BoxShadow(color: AppColors.teal.withOpacity(0.2), blurRadius: 4, spreadRadius: 4)]),
                              alignment: Alignment.center,
                              child: const Text('▶', style: TextStyle(fontSize: 7, fontWeight: FontWeight.w700, color: Colors.black)))),
                          Positioned(top: 33, left: 48,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(color: AppColors.navy.withOpacity(0.9), borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.teal.withOpacity(0.3))),
                              child: Text('62 km/h', style: AppText.mono(size: 9, color: AppColors.teal)),
                            ),
                          ),
                          Positioned(bottom: 8, right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: AppColors.navy.withOpacity(0.9), borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.border)),
                              child: Text('Open in Maps ↗', style: AppText.dm(size: 11, color: AppColors.teal)),
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
                                Text('Current speed', style: AppText.dm(size: 11, color: AppColors.muted)),
                                const SizedBox(height: 3),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text('${vehicle.speed.toInt()}', style: AppText.syne(size: 34, color: AppColors.teal, weight: FontWeight.w800)),
                                    const SizedBox(width: 4),
                                    Text('km/h', style: AppText.dm(size: 12, color: AppColors.muted)),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Max today', style: AppText.dm(size: 11, color: AppColors.muted)),
                                const SizedBox(height: 3),
                                Text('87 km/h', style: AppText.syne(size: 16, color: AppColors.amber)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: 0.52,
                            backgroundColor: AppColors.navy3,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.teal),
                            minHeight: 4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('0', style: AppText.mono(size: 11, color: AppColors.muted)),
                            Text('Limit: 80', style: AppText.dm(size: 11, color: AppColors.amber, weight: FontWeight.w600)),
                            Text('120', style: AppText.mono(size: 11, color: AppColors.muted)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _MiniStatCard(label: 'Odometer', value: '48,201', unit: 'km total')),
                      const SizedBox(width: 8),
                      Expanded(child: _MiniStatCard(label: 'Today dist.', value: '142', unit: 'km today', color: AppColors.teal)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _MiniStatCard(label: 'Engine', value: 'ON', unit: 'since 07:14', color: AppColors.teal)),
                      const SizedBox(width: 8),
                      Expanded(child: _MiniStatCard(label: 'Heading', value: 'NE', unit: '42°')),
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
                        const Icon(Icons.location_on_rounded, size: 22, color: AppColors.teal),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(vehicle.location, style: AppText.dm(size: 13, weight: FontWeight.w600)),
                              const SizedBox(height: 3),
                              Text('-11.4643, 34.0155', style: AppText.mono(size: 11, color: AppColors.muted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(child: _ActionBtn(
                        icon: Icons.history_rounded, label: 'Trip History',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TripHistoryScreen(vehicle: vehicle))),
                      )),
                      const SizedBox(width: 8),
                      Expanded(child: _ActionBtn(
                        icon: Icons.replay_rounded, label: 'Route Replay',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RouteReplayScreen(vehicle: vehicle))),
                      )),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _ActionBtn(icon: Icons.fence_rounded, label: 'Geofences', color: AppColors.amber)),
                      const SizedBox(width: 8),
                      Expanded(child: _ActionBtn(icon: Icons.edit_rounded, label: 'Edit Vehicle', color: AppColors.blue)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SectionHeader(label: 'Recent Activity'),
                  _TimelineItem(title: 'Speed alert — 89 km/h', time: '09:15', color: AppColors.amber),
                  _TimelineItem(title: 'Entered Geofence: Mzuzu', time: '08:50', color: AppColors.teal, isLast: false),
                  _TimelineItem(title: 'Trip started', time: '07:14', color: AppColors.blue, isLast: true),
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

  const _MiniStatCard({required this.label, required this.value, required this.unit, this.color});

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
          Text(value, style: AppText.syne(size: 17, color: color ?? AppColors.text, weight: FontWeight.w800)),
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

  const _ActionBtn({required this.icon, required this.label, this.color = AppColors.teal, this.onTap});

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
            Text(label, style: AppText.dm(size: 12, color: color, weight: FontWeight.w600)),
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

  const _TimelineItem({required this.title, required this.time, required this.color, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(width: 9, height: 9, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            if (!isLast) Container(width: 1, height: 30, color: AppColors.border),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.dm(size: 13, weight: FontWeight.w600)),
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
                      const Icon(Icons.arrow_back_ios_rounded, color: AppColors.teal, size: 18),
                      Text('Fleet', style: AppText.dm(size: 13, color: AppColors.teal)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text('Trip History', style: AppText.syne(size: 18))),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.navy2,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.calendar_month_rounded, size: 20, color: AppColors.muted),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 40),
              children: [
                _DateLabel('Today — 15 May 2026'),
                _TripCard(trip: SampleData.trips[0], tagText: '▶ Active', tagColor: AppColors.teal),
                const SizedBox(height: 14),
                _DateLabel('Yesterday — 14 May'),
                _TripCard(trip: SampleData.trips[1], tagText: '■ Complete', tagColor: AppColors.muted),
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
      child: Text(text.toUpperCase(), style: AppText.dm(size: 11, color: AppColors.muted, weight: FontWeight.w600)),
    );
  }
}

class _TripCard extends StatelessWidget {
  final TripRecord trip;
  final String tagText;
  final Color tagColor;

  const _TripCard({required this.trip, required this.tagText, required this.tagColor});

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
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(trip.id == 't1' ? 'Trip #1' : 'Trip #3', style: AppText.syne(size: 14)),
                  Text('${trip.startTime} — ${trip.endTime}', style: AppText.mono(size: 11)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: tagColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: tagColor.withOpacity(0.25)),
                ),
                child: Text(tagText, style: AppText.dm(size: 10, color: tagColor, weight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _TripStat(value: trip.distanceKm.toInt().toString(), unit: 'km', color: AppColors.teal)),
            const SizedBox(width: 6),
            Expanded(child: _TripStat(value: '${trip.durationHrs.floor()}:${((trip.durationHrs % 1) * 60).toInt().toString().padLeft(2, '0')}', unit: 'hrs')),
            const SizedBox(width: 6),
            Expanded(child: _TripStat(value: trip.avgSpeed.toInt().toString(), unit: 'avg km/h')),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.teal, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(trip.origin, style: AppText.dm(size: 12, color: AppColors.text2)),
          ]),
          Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Container(width: 2, height: 14, color: AppColors.border),
          ),
          Row(children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.teal, width: 2))),
            const SizedBox(width: 8),
            Text(trip.destination, style: AppText.dm(size: 12, color: AppColors.text2)),
          ]),
        ],
      ),
    );
  }
}

class _TripStat extends StatelessWidget {
  final String value, unit;
  final Color color;
  const _TripStat({required this.value, required this.unit, this.color = AppColors.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: AppColors.navy3, borderRadius: BorderRadius.circular(8)),
      child: Column(children: [
        Text(value, style: AppText.syne(size: 15, color: color)),
        Text(unit, style: AppText.dm(size: 11, color: AppColors.muted)),
      ]),
    );
  }
}

class RouteReplayScreen extends StatefulWidget {
  final Vehicle vehicle;
  const RouteReplayScreen({super.key, required this.vehicle});
  @override
  State<RouteReplayScreen> createState() => _RouteReplayScreenState();
}

class _RouteReplayScreenState extends State<RouteReplayScreen> {
  bool _isPlaying = false;
  double _progress = 0.42;
  int _speed = 1;

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: const Color(0xFF0E1E38),
              child: Stack(
                children: [
                  CustomPaint(size: Size.infinite, painter: GridPainter()),
                  Positioned(top: size.height * 0.45, left: 0, right: 0, child: Container(height: 5, color: AppColors.blue.withOpacity(0.18))),
                  Positioned(top: size.height * 0.65, left: 0, right: 0, child: Container(height: 8, color: AppColors.blue.withOpacity(0.25))),
                  Positioned(left: size.width * 0.3, top: 0, bottom: 0, child: Container(width: 5, color: AppColors.blue.withOpacity(0.18))),
                  Positioned(left: size.width * 0.6, top: 0, bottom: 0, child: Container(width: 8, color: AppColors.blue.withOpacity(0.25))),
                  CustomPaint(size: Size.infinite, painter: _RoutePainter(progress: _progress)),
                  Positioned(top: size.height * 0.52, left: size.width * 0.58,
                    child: Container(width: 22, height: 22,
                      decoration: BoxDecoration(color: AppColors.teal, shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [BoxShadow(color: AppColors.teal.withOpacity(0.4), blurRadius: 12, spreadRadius: 3)]),
                      alignment: Alignment.center,
                      child: const Text('▶', style: TextStyle(fontSize: 7, fontWeight: FontWeight.w700, color: Colors.black)))),
                ],
              ),
            ),
          ),
          Positioned(top: 0, left: 0, right: 0,
            child: Container(
              color: AppColors.navy.withOpacity(0.7),
              padding: EdgeInsets.only(top: topPad),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.navy.withOpacity(0.93),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Row(
                          children: [
                            const Icon(Icons.arrow_back_ios_rounded, size: 18, color: AppColors.teal),
                            const SizedBox(width: 4),
                            Text('Fleet', style: AppText.dm(size: 13, color: AppColors.teal)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text('Route Replay — Trip #1', style: AppText.syne(size: 13))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.teal.withOpacity(0.12), borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.teal.withOpacity(0.25))),
                        child: Text('▶ Live', style: AppText.dm(size: 10, color: AppColors.teal, weight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
              decoration: BoxDecoration(
                color: AppColors.navy.withOpacity(0.97),
                border: const Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('07:14', style: AppText.mono(size: 11, color: AppColors.muted)),
                      Text('09:41', style: AppText.mono(size: 11, color: AppColors.teal, weight: FontWeight.w700)),
                      Text('16:45', style: AppText.mono(size: 11, color: AppColors.muted)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.teal,
                      inactiveTrackColor: AppColors.navy3,
                      thumbColor: Colors.white,
                      overlayColor: AppColors.teal.withOpacity(0.1),
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                      trackHeight: 4,
                      overlayShape: SliderComponentShape.noOverlay,
                    ),
                    child: Slider(
                      value: _progress,
                      onChanged: (v) => setState(() => _progress = v),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        GestureDetector(onTap: () => setState(() => _progress = 0),
                          child: const Icon(Icons.skip_previous_rounded, size: 22, color: AppColors.text)),
                        const SizedBox(width: 14),
                        GestureDetector(
                          onTap: () => setState(() => _isPlaying = !_isPlaying),
                          child: Container(
                            width: 44, height: 44,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(colors: [AppColors.teal, AppColors.blue]),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(_isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, color: const Color(0xFF050C1A), size: 26),
                          ),
                        ),
                        const SizedBox(width: 14),
                        GestureDetector(onTap: () => setState(() => _progress = 1.0),
                          child: const Icon(Icons.skip_next_rounded, size: 22, color: AppColors.text)),
                      ]),
                      Row(children: [
                        _SpeedChip(speed: 1, active: _speed == 1, onTap: () => setState(() => _speed = 1)),
                        const SizedBox(width: 6),
                        _SpeedChip(speed: 2, active: _speed == 2, onTap: () => setState(() => _speed = 2)),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(child: _ReplayStat(value: '62', unit: 'km/h', color: AppColors.teal)),
                    Container(width: 1, height: 40, color: AppColors.border),
                    Expanded(child: _ReplayStat(value: '86', unit: 'km done')),
                    Container(width: 1, height: 40, color: AppColors.border),
                    Expanded(child: _ReplayStat(value: 'ON', unit: 'engine', color: AppColors.teal)),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpeedChip extends StatelessWidget {
  final int speed;
  final bool active;
  final VoidCallback onTap;
  const _SpeedChip({required this.speed, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: active ? AppColors.teal : AppColors.navy3,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: active ? AppColors.teal : AppColors.border),
        ),
        child: Text('${speed}×', style: AppText.mono(size: 11, color: active ? const Color(0xFF000000) : AppColors.muted, weight: FontWeight.w700)),
      ),
    );
  }
}

class _ReplayStat extends StatelessWidget {
  final String value, unit;
  final Color? color;
  const _ReplayStat({required this.value, required this.unit, this.color});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(value, style: AppText.syne(size: 14, color: color ?? AppColors.text, weight: FontWeight.w700)),
      Text(unit, style: AppText.dm(size: 11, color: AppColors.muted)),
    ]);
  }
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
    final paint = Paint()..color = AppColors.teal.withOpacity(0.8)..strokeWidth = 3..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawPath(path, paint);
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.7), 6, Paint()..color = AppColors.teal);
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.7), 6, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);
  }
  @override
  bool shouldRepaint(_RoutePainter old) => old.progress != progress;
}


