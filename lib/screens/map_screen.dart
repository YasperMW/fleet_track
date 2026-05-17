import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/shared_widgets.dart';
import 'vehicle_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  Positioned(top: size.height * 0.38, left: 0, right: 0,
                    child: Container(height: 8, color: AppColors.blue.withOpacity(0.25))),
                  Positioned(top: size.height * 0.60, left: 0, right: 0,
                    child: Container(height: 5, color: AppColors.blue.withOpacity(0.15))),
                  Positioned(top: size.height * 0.75, left: 0, right: 0,
                    child: Container(height: 5, color: AppColors.blue.withOpacity(0.15))),
                  Positioned(left: size.width * 0.35, top: 0, bottom: 0,
                    child: Container(width: 8, color: AppColors.blue.withOpacity(0.25))),
                  Positioned(left: size.width * 0.65, top: 0, bottom: 0,
                    child: Container(width: 5, color: AppColors.blue.withOpacity(0.15))),
                  Positioned(top: size.height * 0.20, left: size.width * 0.10,
                    child: Container(width: size.width * 0.22, height: size.height * 0.14,
                      decoration: BoxDecoration(color: AppColors.navy3.withOpacity(0.8), borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.blue.withOpacity(0.1))))),
                  Positioned(top: size.height * 0.20, left: size.width * 0.40,
                    child: Container(width: size.width * 0.18, height: size.height * 0.14,
                      decoration: BoxDecoration(color: AppColors.navy3.withOpacity(0.8), borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.blue.withOpacity(0.1))))),
                  Positioned(top: size.height * 0.45, left: size.width * 0.10,
                    child: Container(width: size.width * 0.18, height: size.height * 0.10,
                      decoration: BoxDecoration(color: AppColors.navy3.withOpacity(0.8), borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.blue.withOpacity(0.1))))),
                  Positioned(top: size.height * 0.45, left: size.width * 0.70,
                    child: Container(width: size.width * 0.18, height: size.height * 0.12,
                      decoration: BoxDecoration(color: AppColors.navy3.withOpacity(0.8), borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.blue.withOpacity(0.1))))),
                  _MapVehicleDot(
                    top: size.height * 0.35, left: size.width * 0.28,
                    color: AppColors.teal, label: '▶', speedText: '62 km/h',
                    borderColor: AppColors.teal2,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VehicleDetailScreen(vehicle: SampleData.vehicles[0]))),
                  ),
                  Positioned(top: size.height * 0.28, left: size.width * 0.32,
                    child: _SpeedBadge(text: '62 km/h', color: AppColors.teal)),
                  _MapVehicleDot(
                    top: size.height * 0.58, left: size.width * 0.58,
                    color: AppColors.muted, label: '■', speedText: '0 km/h',
                    borderColor: const Color(0xFF5A7096),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VehicleDetailScreen(vehicle: SampleData.vehicles[1]))),
                  ),
                  _MapVehicleDot(
                    top: size.height * 0.34, left: size.width * 0.61,
                    color: AppColors.red, label: '⚠', speedText: 'Tamper',
                    borderColor: const Color(0xFFCC2244),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VehicleDetailScreen(vehicle: SampleData.vehicles[2]))),
                  ),
                  Positioned(top: size.height * 0.27, left: size.width * 0.63,
                    child: _SpeedBadge(text: 'Tamper', color: AppColors.red)),
                  Positioned(top: 84, right: 14,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.navy.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 44, height: 44,
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                alignment: Alignment.center,
                                child: const Text('+', style: TextStyle(fontSize: 20, color: AppColors.text)),
                              ),
                            ),
                          ),
                          Container(width: 32, height: 1, color: AppColors.border),
                          SizedBox(
                            width: 44, height: 44,
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                alignment: Alignment.center,
                                child: const Text('−', style: TextStyle(fontSize: 20, color: AppColors.text)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(top: 56, right: 10,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.navy.withOpacity(0.95),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
                children: [
                  _LegendItem(color: AppColors.teal, label: '▶ Moving'),
                  const SizedBox(height: 5),
                  _LegendItem(color: AppColors.muted, label: '■ Parked'),
                  const SizedBox(height: 5),
                  _LegendItem(color: AppColors.red, label: '⚠ Alert'),
                ],
              ),
            ),
          ),
          Positioned(top: 0, left: 0, right: 0,
            child: Container(
              color: AppColors.navy.withOpacity(0.7),
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                children: [
                  Padding(
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
                          const Icon(Icons.search_rounded, size: 16, color: AppColors.muted),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: AppText.dm(size: 12, color: AppColors.text),
                              decoration: InputDecoration.collapsed(
                                hintText: 'Search vehicles, locations\u2026',
                                hintStyle: AppText.dm(size: 12, color: AppColors.muted),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: AppColors.teal.withOpacity(0.12), borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.teal.withOpacity(0.25))),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.teal, shape: BoxShape.circle)),
                              const SizedBox(width: 4),
                              Text('Live', style: AppText.dm(size: 10, color: AppColors.teal, weight: FontWeight.w600)),
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
          Positioned(left: 10, right: 10, bottom: 74,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.navy.withOpacity(0.96),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Fleet Status', style: AppText.syne(size: 14)),
                      Text('Updated 2s ago', style: AppText.dm(size: 11, color: AppColors.muted)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(child: _FleetStat(value: '1', label: 'Moving', color: AppColors.teal)),
                    Container(width: 1, height: 40, color: AppColors.border),
                    Expanded(child: _FleetStat(value: '1', label: 'Parked', color: AppColors.text)),
                    Container(width: 1, height: 40, color: AppColors.border),
                    Expanded(child: _FleetStat(value: '1', label: 'Alert', color: AppColors.red)),
                  ]),
                  const SizedBox(height: 10),
                  AlertBanner(alert: SampleData.alerts.first, onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => VehicleDetailScreen(vehicle: SampleData.vehicles[2])));
                  }),
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
  const _FleetStat({required this.value, required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(value, style: AppText.syne(size: 20, color: color, weight: FontWeight.w800)),
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
      Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 6),
      Text(label, style: AppText.dm(size: 10, color: AppColors.text2)),
    ]);
  }
}

class _MapVehicleDot extends StatelessWidget {
  final double top, left;
  final Color color, borderColor;
  final String label, speedText;
  final VoidCallback? onTap;

  const _MapVehicleDot({
    required this.top, required this.left,
    required this.color, required this.borderColor,
    required this.label, required this.speedText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(top: top - 11, left: left - 11,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 44, height: 44,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 22, height: 22,
                decoration: BoxDecoration(
                  color: color, shape: BoxShape.circle,
                  border: Border.all(color: borderColor, width: 2),
                  boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 4, spreadRadius: 4)],
                ),
                alignment: Alignment.center,
                child: Text(label, style: TextStyle(fontSize: 7, fontWeight: FontWeight.w700,
                  color: color == AppColors.teal ? Colors.black : Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpeedBadge extends StatelessWidget {
  final String text;
  final Color color;
  const _SpeedBadge({required this.text, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.navy.withOpacity(0.9),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(text, style: AppText.mono(size: 9, color: color)),
    );
  }
}


