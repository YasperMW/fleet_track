import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class GeofencesScreen extends StatefulWidget {
  const GeofencesScreen({super.key});

  @override
  State<GeofencesScreen> createState() => _GeofencesScreenState();
}

class _GeofencesScreenState extends State<GeofencesScreen> {
  final _api = ApiService();
  List<Geofence> _geofences = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final geofences = await _api.getGeofences();
      if (!mounted) return;
      setState(() {
        _geofences = geofences;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e is ApiException ? e.message : 'Failed to load geofences'),
        backgroundColor: AppColors.red,
      ));
    }
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'circular':
        return Icons.business_rounded;
      default:
        return Icons.block_rounded;
    }
  }

  Color _colorForStatus(String status) {
    switch (status) {
      case 'active':
        return AppColors.teal;
      case 'paused':
        return AppColors.amber;
      default:
        return AppColors.muted;
    }
  }

  String _triggerLabel(String trigger) {
    switch (trigger) {
      case 'enter_exit':
        return 'Enter + Exit';
      case 'exit_only':
        return 'Exit only';
      case 'enter_only':
        return 'Enter only';
      default:
        return trigger;
    }
  }

  String _subtitle(Geofence g) {
    final type = g.zoneType == 'circular' ? 'Circular' : 'Polygon';
    final radius = g.radiusM != null ? ' · ${g.radiusM}m radius' : '';
    return '$type$radius';
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final size = MediaQuery.of(context).size;

    final activeCount = _geofences.where((g) => g.status == 'active').length;

    return Scaffold(
      backgroundColor: AppColors.navy,
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.teal))
          : Column(
        children: [
          SizedBox(height: topPad),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back_ios_rounded,
                          color: AppColors.teal, size: 18),
                      Text('Settings',
                          style: AppText.dm(size: 13, color: AppColors.teal)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Geofences', style: AppText.syne(size: 18)),
                      Text('$activeCount zones active',
                          style: AppText.dm(size: 11, color: AppColors.muted)),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [AppColors.teal, AppColors.blue]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.add_rounded,
                        size: 18, color: Color(0xFF050C1A)),
                    const SizedBox(width: 4),
                    Text('Add',
                        style: AppText.dm(
                            size: 13,
                            color: const Color(0xFF050C1A),
                            weight: FontWeight.w700)),
                  ]),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              height: 120,
              width: double.infinity,
              child: Stack(
                children: [
                  Container(
                      color: const Color(0xFF0E1E38),
                      margin: const EdgeInsets.symmetric(horizontal: 14)),
                  CustomPaint(
                      size: Size(size.width - 28, 120), painter: GridPainter()),
                  Positioned(
                      top: 60,
                      left: 14,
                      right: 14,
                      child: Container(
                          height: 5,
                          color: AppColors.blue.withValues(alpha: 0.15))),
                  Positioned(
                      left: 14 + (size.width - 28) * 0.4,
                      top: 0,
                      bottom: 0,
                      child: Container(
                          width: 5,
                          color: AppColors.blue.withValues(alpha: 0.15))),
                  Positioned(
                    top: 20,
                    left: 100,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.teal.withValues(alpha: 0.4),
                            width: 1.5),
                        color: AppColors.teal.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 55,
                    left: 195,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.blue.withValues(alpha: 0.4),
                            width: 1.5),
                        color: AppColors.blue.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  CustomPaint(
                      size: Size(size.width - 28, 120),
                      painter: _PolygonPainter()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 40),
              children: _geofences.map((g) => _GeofenceItem(
                icon: _iconForType(g.zoneType),
                title: g.name,
                subtitle: _subtitle(g),
                status: g.status == 'active' ? 'Active' : 'Paused',
                statusColor: _colorForStatus(g.status),
                detail: _triggerLabel(g.triggerOn),
                iconColor: g.status == 'paused' ? AppColors.amber : null,
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _GeofenceItem extends StatelessWidget {
  final IconData icon;
  final String title, subtitle, status, detail;
  final Color statusColor;
  final Color? iconColor;

  const _GeofenceItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusColor,
    required this.detail,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.navy2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: (iconColor ?? AppColors.blue).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: (iconColor ?? AppColors.blue).withValues(alpha: 0.2)),
            ),
            child: Icon(icon, size: 18, color: iconColor ?? AppColors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppText.dm(size: 13, weight: FontWeight.w600)),
                Text(subtitle,
                    style: AppText.dm(size: 11, color: AppColors.muted)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: statusColor.withValues(alpha: 0.25)),
                ),
                child: Text(status,
                    style: AppText.dm(
                        size: 10, color: statusColor, weight: FontWeight.w600)),
              ),
              const SizedBox(height: 4),
              Text(detail, style: AppText.dm(size: 11, color: AppColors.muted)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PolygonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(15, 70)
      ..lineTo(45, 45)
      ..lineTo(65, 75)
      ..lineTo(35, 90)
      ..close();
    canvas.drawPath(
        path,
        Paint()
          ..color = AppColors.amber.withValues(alpha: 0.1)
          ..style = PaintingStyle.fill);
    canvas.drawPath(
        path,
        Paint()
          ..color = AppColors.amber.withValues(alpha: 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);
  }

  @override
  bool shouldRepaint(_) => false;
}
