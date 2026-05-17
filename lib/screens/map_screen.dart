import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/shared_widgets.dart';
import 'vehicle_detail_screen.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Stack(
        children: [
          // Full-screen map background
          Positioned.fill(
            child: Container(
              color: const Color(0xFF0E1E38),
              child: Stack(
                children: [
                  CustomPaint(size: Size.infinite, painter: _GridPainter()),
                  // Roads horizontal
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.35,
                    left: 0, right: 0,
                    child: Container(height: 8,
                        color: AppColors.blue.withOpacity(0.25)),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.55,
                    left: 0, right: 0,
                    child: Container(height: 5,
                        color: AppColors.blue.withOpacity(0.18)),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.68,
                    left: 0, right: 0,
                    child: Container(height: 8,
                        color: AppColors.blue.withOpacity(0.25)),
                  ),
                  // Roads vertical
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.28,
                    top: 0, bottom: 0,
                    child: Container(width: 8,
                        color: AppColors.blue.withOpacity(0.22)),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.62,
                    top: 0, bottom: 0,
                    child: Container(width: 5,
                        color: AppColors.blue.withOpacity(0.15)),
                  ),
                  // Vehicle dots
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.28,
                    left: MediaQuery.of(context).size.width * 0.22,
                    child: _MapVehicleDot(
                      color: AppColors.teal,
                      label: '▶',
                      speedText: '62 km/h',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VehicleDetailScreen(
                              vehicle: SampleData.vehicles[0]),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.52,
                    left: MediaQuery.of(context).size.width * 0.58,
                    child: _MapVehicleDot(
                      color: AppColors.muted,
                      label: '■',
                      speedText: '0 km/h',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VehicleDetailScreen(
                              vehicle: SampleData.vehicles[1]),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.42,
                    left: MediaQuery.of(context).size.width * 0.65,
                    child: _MapVehicleDot(
                      color: AppColors.red,
                      label: '⚠',
                      speedText: 'Alert',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VehicleDetailScreen(
                              vehicle: SampleData.vehicles[2]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Status bar overlay
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              color: AppColors.navy.withOpacity(0.8),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('FleetTrack',
                        style: AppText.syne(size: 16, color: AppColors.teal)),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.navy2,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.layers_rounded,
                                  color: AppColors.muted, size: 16),
                              const SizedBox(width: 4),
                              Text('Satellite',
                                  style: AppText.dm(
                                      size: 12, color: AppColors.muted)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.navy2,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Icon(Icons.my_location_rounded,
                              color: AppColors.teal, size: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Map legend
          Positioned(
            left: 14,
            bottom: 84,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.navy.withOpacity(0.92),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Legend',
                      style: AppText.dm(
                          size: 11, color: AppColors.muted,
                          weight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  _LegendItem(
                      color: AppColors.teal, label: 'Moving'),
                  const SizedBox(height: 4),
                  _LegendItem(
                      color: AppColors.muted, label: 'Parked'),
                  const SizedBox(height: 4),
                  _LegendItem(
                      color: AppColors.red, label: 'Alert'),
                ],
              ),
            ),
          ),

          // Fleet status overlay
          Positioned(
            right: 14,
            bottom: 84,
            child: Container(
              width: 180,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.navy.withOpacity(0.95),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Fleet Status',
                          style: AppText.syne(size: 14)),
                      Text('Updated 2s ago',
                          style: AppText.dm(size: 11, color: AppColors.muted)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                          child: _StatusStat(
                              value: '1',
                              label: 'Moving',
                              color: AppColors.teal)),
                      Container(
                          width: 1, height: 40, color: AppColors.border),
                      Expanded(
                          child: _StatusStat(
                              value: '1',
                              label: 'Parked',
                              color: AppColors.text)),
                      Container(
                          width: 1, height: 40, color: AppColors.border),
                      Expanded(
                          child: _StatusStat(
                              value: '1',
                              label: 'Alert',
                              color: AppColors.red)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  AlertBanner(alert: SampleData.alerts.first),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10, height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: AppText.dm(size: 11, color: AppColors.text2)),
      ],
    );
  }
}

class _StatusStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatusStat(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppText.syne(size: 20, color: color, weight: FontWeight.w800)),
        Text(label, style: AppText.dm(size: 11, color: AppColors.muted)),
      ],
    );
  }
}

class _MapVehicleDot extends StatelessWidget {
  final Color color;
  final String label;
  final String speedText;
  final VoidCallback? onTap;

  const _MapVehicleDot({
    required this.color,
    required this.label,
    required this.speedText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.6), width: 2),
              boxShadow: [
                BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 3)
              ],
            ),
            alignment: Alignment.center,
            child: Text(label,
                style: TextStyle(
                    fontSize: 9,
                    color: color == AppColors.teal ? Colors.black : Colors.white)),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.navy.withOpacity(0.9),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Text(speedText, style: AppText.mono(size: 9, color: color)),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
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
