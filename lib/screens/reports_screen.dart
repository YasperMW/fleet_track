import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final _api = ApiService();
  bool _loading = true;

  int _totalMileage = 0;
  int _totalTrips = 0;
  int _totalAlerts = 0;
  List<double> _dailyMileage = [0, 0, 0, 0, 0, 0, 0];
  List<String> _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  String _dateRangeStart = '';
  String _dateRangeEnd = '';

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final data = await _api.getReportSummary();
      if (!mounted) return;
      setState(() {
        _totalMileage = (data['total_mileage'] as num).toInt();
        _totalTrips = (data['total_trips'] as num).toInt();
        _totalAlerts = (data['total_alerts'] as num).toInt();
        _dailyMileage =
            (data['daily_mileage'] as List).map((e) => (e as num).toDouble()).toList();
        _weekDays =
            (data['week_days'] as List).map((e) => e.toString()).toList();
        _dateRangeStart = data['date_range_start'] ?? '';
        _dateRangeEnd = data['date_range_end'] ?? '';
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final maxVal = _dailyMileage.reduce((a, b) => a > b ? a : b);

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
                      Expanded(
                          child: Text('Reports',
                              style: AppText.syne(size: 18))),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.navy2,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(Icons.upload_rounded,
                            size: 20, color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.navy2,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.date_range_rounded,
                                  size: 22, color: AppColors.blue),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Date range',
                                        style: AppText.dm(
                                            size: 11, color: AppColors.muted)),
                                    const SizedBox(height: 3),
                                    Text('$_dateRangeStart — $_dateRangeEnd',
                                        style: AppText.dm(
                                            size: 13,
                                            weight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                              Text('Edit ›',
                                  style: AppText.dm(
                                      size: 13,
                                      color: AppColors.teal,
                                      weight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(children: [
                          Expanded(
                              child: _KpiCard(
                                  value: _formatNum(_totalMileage),
                                  unit: 'km',
                                  color: AppColors.teal)),
                          const SizedBox(width: 6),
                          Expanded(
                              child: _KpiCard(
                                  value: '$_totalTrips',
                                  unit: 'trips')),
                          const SizedBox(width: 6),
                          Expanded(
                              child: _KpiCard(
                                  value: '$_totalAlerts',
                                  unit: 'alerts',
                                  color: _totalAlerts > 0
                                      ? AppColors.amber
                                      : null)),
                        ]),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.navy2,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Daily Mileage',
                                  style: AppText.dm(
                                      size: 13, weight: FontWeight.w600)),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 60,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    for (int i = 0;
                                        i < _dailyMileage.length;
                                        i++) ...[
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(horizontal: 3),
                                              child: Container(
                                                height: maxVal > 0
                                                    ? 42 *
                                                        (_dailyMileage[i] /
                                                            maxVal)
                                                    : 0,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin:
                                                        Alignment.bottomCenter,
                                                    end: Alignment.topCenter,
                                                    colors: [
                                                      AppColors.teal,
                                                      AppColors.teal
                                                          .withValues(
                                                              alpha: 0.4)
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(_weekDays[i],
                                                style: AppText.mono(
                                                    size: 9,
                                                    color: AppColors.muted)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text('EXPORT REPORTS',
                            style: AppText.dm(
                                size: 11,
                                color: AppColors.muted,
                                weight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        _ReportRow(
                          icon: Icons.description_rounded,
                          iconColor: AppColors.teal,
                          title: 'Fleet Summary',
                          subtitle: 'All vehicles · Mileage, trips, alerts',
                          badge: 'PDF',
                          badgeColor: AppColors.teal,
                          onTap: () => _showExportSnackbar(),
                        ),
                        _ReportRow(
                          icon: Icons.speed_rounded,
                          iconColor: AppColors.blue,
                          title: 'Speed Violations',
                          subtitle: 'Speed events, times, locations',
                          badge: 'CSV',
                          badgeColor: AppColors.blue,
                          onTap: () => _showExportSnackbar(),
                        ),
                        _ReportRow(
                          icon: Icons.notifications_active_rounded,
                          iconColor: AppColors.red,
                          title: 'Tamper Log',
                          subtitle: 'All tamper events with coordinates',
                          badge: 'PDF',
                          badgeColor: AppColors.red,
                          onTap: () => _showExportSnackbar(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _showExportSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Export coming soon'),
      backgroundColor: AppColors.teal,
      behavior: SnackBarBehavior.floating,
    ));
  }

  String _formatNum(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }
}

class _KpiCard extends StatelessWidget {
  final String value, unit;
  final Color? color;
  const _KpiCard({required this.value, required this.unit, this.color});
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
        children: [
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

class _ReportRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title, subtitle, badge;
  final Color badgeColor;
  final VoidCallback? onTap;

  const _ReportRow(
      {required this.icon,
      required this.iconColor,
      required this.title,
      required this.subtitle,
      required this.badge,
      required this.badgeColor,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.navy2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                          AppText.dm(size: 13, weight: FontWeight.w600)),
                  Text(subtitle,
                      style: AppText.dm(size: 11, color: AppColors.muted)),
                ],
              ),
            ),
            Text(badge,
                style: AppText.mono(
                    size: 12,
                    color: badgeColor,
                    weight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
