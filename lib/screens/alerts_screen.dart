import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import 'vehicle_detail_screen.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  int _filterIndex = 0;
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
    }
    if (_filterIndex == 2) {
      return _alerts.where((a) => a.severity == AlertSeverity.warning).toList();
    }
    if (_filterIndex == 3) {
      return _alerts.where((a) => a.severity == AlertSeverity.info).toList();
    }
    return _alerts;
  }

  void _resolveAlert(AlertItem alert) {
    setState(() => _alerts.remove(alert));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${alert.title} resolved'),
      backgroundColor: AppColors.teal,
      behavior: SnackBarBehavior.floating,
    ));
  }

  void _viewOnMap(AlertItem alert) {
    try {
      final vehicle =
          SampleData.vehicles.firstWhere((v) => v.id == alert.vehicleId);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => VehicleDetailScreen(vehicle: vehicle)));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final critical =
        _alerts.where((a) => a.severity == AlertSeverity.critical).length;

    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Column(
        children: [
          SizedBox(height: topPad),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Alerts', style: AppText.syne(size: 18)),
                      Text('${_alerts.length} total · $critical unread',
                          style: AppText.dm(size: 11, color: AppColors.muted)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() => _alerts.clear());
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('All alerts resolved'),
                      backgroundColor: AppColors.teal,
                      behavior: SnackBarBehavior.floating,
                    ));
                  },
                  child: Text('Mark all read',
                      style: AppText.dm(
                          size: 12,
                          color: AppColors.teal,
                          weight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 34,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              scrollDirection: Axis.horizontal,
              children: [
                _FilterChip(
                    label: 'All (${_alerts.length})',
                    active: _filterIndex == 0,
                    onTap: () => setState(() => _filterIndex = 0)),
                const SizedBox(width: 6),
                _FilterChip(
                    label:
                        'Critical (${_alerts.where((a) => a.severity == AlertSeverity.critical).length})',
                    active: _filterIndex == 1,
                    color: AppColors.red,
                    onTap: () => setState(() => _filterIndex = 1)),
                const SizedBox(width: 6),
                _FilterChip(
                    label:
                        'Warning (${_alerts.where((a) => a.severity == AlertSeverity.warning).length})',
                    active: _filterIndex == 2,
                    color: AppColors.amber,
                    onTap: () => setState(() => _filterIndex = 2)),
                const SizedBox(width: 6),
                _FilterChip(
                    label:
                        'Info (${_alerts.where((a) => a.severity == AlertSeverity.info).length})',
                    active: _filterIndex == 3,
                    color: AppColors.blue,
                    onTap: () => setState(() => _filterIndex = 3)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.teal.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                  color:
                                      AppColors.teal.withValues(alpha: 0.15)),
                            ),
                            child: Icon(Icons.check_circle_outline_rounded,
                                size: 42,
                                color: AppColors.teal.withValues(alpha: 0.5)),
                          ),
                          const SizedBox(height: 20),
                          Text('All clear', style: AppText.syne(size: 16)),
                          const SizedBox(height: 8),
                          Text('No alerts to show. You\u2019re all caught up!',
                              style:
                                  AppText.dm(size: 13, color: AppColors.muted),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 40),
                    children: [
                      if (_filtered
                          .any((a) => a.severity == AlertSeverity.critical))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(children: [
                            const Icon(Icons.error_rounded,
                                size: 14, color: AppColors.red),
                            const SizedBox(width: 6),
                            Text('Unread',
                                style: AppText.dm(
                                    size: 11,
                                    color: AppColors.red,
                                    weight: FontWeight.w600)),
                          ]),
                        ),
                      ..._filtered.map((a) => _AlertCard(
                          alert: a,
                          onResolve: () => _resolveAlert(a),
                          onViewOnMap: () => _viewOnMap(a))),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  const _FilterChip(
      {required this.label,
      required this.active,
      this.color = AppColors.teal,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: active
              ? (color == AppColors.teal
                  ? AppColors.teal
                  : color.withValues(alpha: 0.1))
              : AppColors.navy3,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? color : AppColors.border),
        ),
        child: Text(label,
            style: AppText.dm(
                size: 12,
                color: active
                    ? (color == AppColors.teal ? Colors.black : color)
                    : AppColors.muted,
                weight: FontWeight.w600)),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final AlertItem alert;
  final VoidCallback? onResolve, onViewOnMap;

  const _AlertCard({required this.alert, this.onResolve, this.onViewOnMap});

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

  String get _severityLabel {
    switch (alert.severity) {
      case AlertSeverity.critical:
        return 'Critical';
      case AlertSeverity.warning:
        return 'Warning';
      case AlertSeverity.info:
        return 'Info';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSevere = alert.severity == AlertSeverity.critical;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
      decoration: BoxDecoration(
        color: isSevere
            ? AppColors.red.withValues(alpha: 0.05)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border:
            isSevere ? Border(left: BorderSide(color: _color, width: 3)) : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(children: [
            Container(
                width: 9,
                height: 9,
                decoration:
                    BoxDecoration(color: _color, shape: BoxShape.circle)),
          ]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: _color.withValues(alpha: 0.35)),
                            ),
                            child: Text(_severityLabel,
                                style: AppText.dm(
                                    size: 10,
                                    color: _color,
                                    weight: FontWeight.w600)),
                          ),
                          const SizedBox(height: 4),
                          Text(alert.title,
                              style: AppText.dm(
                                  size: 13,
                                  color:
                                      isSevere ? AppColors.red : AppColors.text,
                                  weight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    Text(alert.time,
                        style: AppText.mono(size: 11, color: AppColors.muted)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(alert.message,
                    style: AppText.dm(size: 12, color: AppColors.text2)),
                if (alert.severity == AlertSeverity.critical) ...[
                  const SizedBox(height: 3),
                  Text('-11.4643, 34.0155',
                      style: AppText.mono(size: 11, color: AppColors.muted)),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      onTap: onResolve,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.teal.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: AppColors.teal.withValues(alpha: 0.25)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle_outline_rounded,
                                size: 12, color: AppColors.teal),
                            const SizedBox(width: 4),
                            Text('Resolve',
                                style: AppText.dm(
                                    size: 10,
                                    color: AppColors.teal,
                                    weight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onViewOnMap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.blue.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: AppColors.blue.withValues(alpha: 0.25)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.map_rounded,
                                size: 12, color: AppColors.blue),
                            const SizedBox(width: 4),
                            Text('View on Map',
                                style: AppText.dm(
                                    size: 10,
                                    color: AppColors.blue,
                                    weight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
