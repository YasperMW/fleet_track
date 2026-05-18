import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Column(
        children: [
          SizedBox(height: topPad),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
            child: Row(
              children: [
                Expanded(child: Text('Reports', style: AppText.syne(size: 18))),
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
                              Text('1 May — 15 May 2026',
                                  style: AppText.dm(
                                      size: 13, weight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        Text('Edit \u203A',
                            style: AppText.dm(
                                size: 13,
                                color: AppColors.teal,
                                weight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Row(children: [
                    Expanded(
                        child: _KpiCard(
                            value: '3,241', unit: 'km', color: AppColors.teal)),
                    SizedBox(width: 6),
                    Expanded(child: _KpiCard(value: '47', unit: 'trips')),
                    SizedBox(width: 6),
                    Expanded(
                        child: _KpiCard(
                            value: '6',
                            unit: 'alerts',
                            color: AppColors.amber)),
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
                            style:
                                AppText.dm(size: 13, weight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 60,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              for (int i = 0;
                                  i < SampleData.weeklyMileage.length;
                                  i++) ...[
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 3),
                                        child: Container(
                                          height: 42 *
                                              (SampleData.weeklyMileage[i] /
                                                  210),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              colors: i == 3
                                                  ? [
                                                      AppColors.amber,
                                                      AppColors.amber
                                                          .withValues(
                                                              alpha: 0.4)
                                                    ]
                                                  : i == 9
                                                      ? [
                                                          AppColors.red,
                                                          AppColors.red
                                                              .withValues(
                                                                  alpha: 0.4)
                                                        ]
                                                      : [
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
                                      Text(SampleData.weekDays[i],
                                          style: AppText.mono(
                                              size: 9, color: AppColors.muted)),
                                    ],
                                  ),
                                ),
                                if (i == 6) const SizedBox(width: 0),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text('EXPORT REPORTS'.toUpperCase(),
                      style: AppText.dm(
                          size: 11,
                          color: AppColors.muted,
                          weight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  const _ReportRow(
                    icon: Icons.description_rounded,
                    iconColor: AppColors.teal,
                    title: 'Fleet Summary',
                    subtitle: 'All vehicles · Mileage, trips, alerts',
                    badge: 'PDF',
                    badgeColor: AppColors.teal,
                  ),
                  const _ReportRow(
                    icon: Icons.speed_rounded,
                    iconColor: AppColors.blue,
                    title: 'Speed Violations',
                    subtitle: 'Speed events, times, locations',
                    badge: 'CSV',
                    badgeColor: AppColors.blue,
                  ),
                  const _ReportRow(
                    icon: Icons.notifications_active_rounded,
                    iconColor: AppColors.red,
                    title: 'Tamper Log',
                    subtitle: 'All tamper events with coordinates',
                    badge: 'PDF',
                    badgeColor: AppColors.red,
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

  const _ReportRow(
      {required this.icon,
      required this.iconColor,
      required this.title,
      required this.subtitle,
      required this.badge,
      required this.badgeColor});

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
                    style: AppText.dm(size: 13, weight: FontWeight.w600)),
                Text(subtitle,
                    style: AppText.dm(size: 11, color: AppColors.muted)),
              ],
            ),
          ),
          Text(badge,
              style: AppText.mono(
                  size: 12, color: badgeColor, weight: FontWeight.w700)),
        ],
      ),
    );
  }
}
