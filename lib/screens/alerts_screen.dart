import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/shared_widgets.dart';
import 'vehicle_detail_screen.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  int _filterIndex = 0; // 0=All, 1=Critical, 2=Warning, 3=Info
  late List<AlertItem> _alerts;

  @override
  void initState() {
    super.initState();
    _alerts = List.from(SampleData.alerts);
  }

  List<AlertItem> get _filtered {
    if (_filterIndex == 1) {
      return _alerts
          .where((a) => a.severity == AlertSeverity.critical)
          .toList();
    } else if (_filterIndex == 2) {
      return _alerts
          .where((a) => a.severity == AlertSeverity.warning)
          .toList();
    } else if (_filterIndex == 3) {
      return _alerts
          .where((a) => a.severity == AlertSeverity.info)
          .toList();
    }
    return _alerts;
  }

  void _resolveAlert(AlertItem alert) {
    setState(() => _alerts.remove(alert));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${alert.title} resolved'),
        backgroundColor: AppColors.teal,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _viewOnMap(AlertItem alert) {
    try {
      final vehicle = SampleData.vehicles.firstWhere((v) => v.id == alert.vehicleId);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VehicleDetailScreen(vehicle: vehicle)),
      );
    } catch (_) {}
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Alerts', style: AppText.syne(size: 18)),
                      Text('${_alerts.length} total · ${_alerts.where((a) => a.severity == AlertSeverity.critical).length} unresolved',
                          style: AppText.dm(size: 11, color: AppColors.muted)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.red.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.red.withOpacity(0.25)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_rounded,
                          color: AppColors.red, size: 14),
                      const SizedBox(width: 4),
                      Text('1 Critical',
                          style: AppText.dm(
                              size: 11,
                              color: AppColors.red,
                              weight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Filter chips
          SizedBox(
            height: 34,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              scrollDirection: Axis.horizontal,
              children: [
                _AlertFilterChip(
                    label: 'All',
                    active: _filterIndex == 0,
                    onTap: () => setState(() => _filterIndex = 0)),
                const SizedBox(width: 6),
                _AlertFilterChip(
                    label: 'Critical',
                    active: _filterIndex == 1,
                    color: AppColors.red,
                    onTap: () => setState(() => _filterIndex = 1)),
                const SizedBox(width: 6),
                _AlertFilterChip(
                    label: 'Warning',
                    active: _filterIndex == 2,
                    color: AppColors.amber,
                    onTap: () => setState(() => _filterIndex = 2)),
                const SizedBox(width: 6),
                _AlertFilterChip(
                    label: 'Info',
                    active: _filterIndex == 3,
                    color: AppColors.blue,
                    onTap: () => setState(() => _filterIndex = 3)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              padding:
                  const EdgeInsets.fromLTRB(14, 0, 14, 40),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                final alert = _filtered[i];
                return _AlertCard(
                  alert: alert,
                  onResolve: () => _resolveAlert(alert),
                  onViewOnMap: () => _viewOnMap(alert),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertFilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  const _AlertFilterChip({
    required this.label,
    required this.active,
    this.color = AppColors.teal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? color.withOpacity(0.15) : AppColors.navy3,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: active ? color : AppColors.border),
        ),
        child: Text(
          label,
          style: AppText.dm(
            size: 12,
            color: active ? color : AppColors.muted,
            weight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final AlertItem alert;
  final VoidCallback? onResolve;
  final VoidCallback? onViewOnMap;

  const _AlertCard({
    required this.alert,
    this.onResolve,
    this.onViewOnMap,
  });

  Color get _color {
    switch (alert.severity) {
      case AlertSeverity.critical:
        return AppColors.red;
      case AlertSeverity.warning:
        return AppColors.amber;
      case AlertSeverity.info:
        return AppColors.blue;
    }
  }

  IconData get _icon {
    switch (alert.severity) {
      case AlertSeverity.critical:
        return Icons.warning_rounded;
      case AlertSeverity.warning:
        return Icons.error_outline_rounded;
      case AlertSeverity.info:
        return Icons.info_rounded;
    }
  }

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
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_icon, color: _color, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(alert.title,
                        style: AppText.dm(
                            size: 13, weight: FontWeight.w600)),
                    Text(alert.message,
                        style: AppText.dm(
                            size: 11, color: AppColors.text2)),
                  ],
                ),
              ),
              SeverityTag(severity: alert.severity),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.access_time_rounded,
                  size: 13, color: AppColors.muted),
              const SizedBox(width: 4),
              Text(alert.time,
                  style: AppText.mono(size: 11)),
              const Spacer(),
              if (alert.severity == AlertSeverity.critical) ...[
                _ActionChip(
                  label: 'Resolve',
                  color: AppColors.teal,
                  icon: Icons.check_rounded,
                  onTap: onResolve,
                ),
                const SizedBox(width: 8),
              ],
              _ActionChip(
                label: 'View on Map',
                color: AppColors.blue,
                icon: Icons.map_rounded,
                onTap: onViewOnMap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  const _ActionChip({
    required this.label,
    required this.color,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
            Text(label,
                style: AppText.dm(
                    size: 11, color: color, weight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
