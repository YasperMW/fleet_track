import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/shared_widgets.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _tabIndex = 0;
  final _tabs = ['Mileage', 'Fuel', 'Alerts', 'Trips'];

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
                    child: Text('Reports', style: AppText.syne(size: 18))),
                // Date range picker
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.navy2,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_month_rounded,
                          size: 16, color: AppColors.muted),
                      const SizedBox(width: 6),
                      Text('May 8 – 15',
                          style: AppText.dm(size: 12)),
                      const SizedBox(width: 4),
                      const Icon(Icons.expand_more_rounded,
                          size: 16, color: AppColors.muted),
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
                  child: const Icon(Icons.download_rounded,
                      size: 18, color: AppColors.teal),
                ),
              ],
            ),
          ),

          // Tabs
          SizedBox(
            height: 36,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              scrollDirection: Axis.horizontal,
              itemCount: _tabs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, i) {
                final active = i == _tabIndex;
                return GestureDetector(
                  onTap: () => setState(() => _tabIndex = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.teal.withOpacity(0.15)
                          : AppColors.navy3,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: active
                              ? AppColors.teal
                              : AppColors.border),
                    ),
                    child: Text(_tabs[i],
                        style: AppText.dm(
                          size: 12,
                          color: active
                              ? AppColors.teal
                              : AppColors.muted,
                          weight: active
                              ? FontWeight.w600
                              : FontWeight.w400,
                        )),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary cards
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          label: 'Total Distance',
                          value: '1,847',
                          unit: 'km this week',
                          trend: '+12%',
                          trendUp: true,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _SummaryCard(
                          label: 'Active Hours',
                          value: '38.5',
                          unit: 'hrs this week',
                          trend: '+5%',
                          trendUp: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          label: 'Avg Speed',
                          value: '56',
                          unit: 'km/h',
                          trend: '-2%',
                          trendUp: false,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _SummaryCard(
                          label: 'Total Trips',
                          value: '24',
                          unit: 'completed',
                          trend: '+8%',
                          trendUp: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Weekly mileage chart
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.navy2,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Weekly Mileage',
                                style: AppText.dm(
                                    size: 13,
                                    weight: FontWeight.w600)),
                            Text('+12% ↑',
                                style: AppText.dm(
                                    size: 12,
                                    color: AppColors.teal,
                                    weight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _BarChart(
                          data: SampleData.weeklyMileage,
                          labels: SampleData.weekDays,
                          highlightIndex: 3,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Per-vehicle breakdown
                  SectionHeader(label: 'Vehicle Breakdown'),
                  ...SampleData.vehicles.map(
                    (v) => _VehicleReportRow(vehicle: v),
                  ),
                  const SizedBox(height: 14),

                  // Recent activity
                  SectionHeader(label: 'Recent Trips'),
                  ...SampleData.trips.map(
                    (t) => _TripReportRow(trip: t),
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

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final String trend;
  final bool trendUp;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.trend,
    required this.trendUp,
  });

  @override
  Widget build(BuildContext context) {
    final trendColor = trendUp ? AppColors.teal : AppColors.red;

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
          Text(label,
              style: AppText.dm(size: 11, color: AppColors.muted)),
          const SizedBox(height: 6),
          Text(value,
              style: AppText.syne(
                  size: 24, weight: FontWeight.w800)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(unit,
                  style: AppText.dm(size: 11, color: AppColors.muted)),
              Text(trend,
                  style: AppText.dm(
                      size: 11,
                      color: trendColor,
                      weight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  final List<double> data;
  final List<String> labels;
  final int highlightIndex;

  const _BarChart({
    required this.data,
    required this.labels,
    required this.highlightIndex,
  });

  @override
  Widget build(BuildContext context) {
    final maxVal = data.reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        SizedBox(
          height: 80,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(data.length, (i) {
              final heightFraction = data[i] / maxVal;
              final isHighlight = i == highlightIndex;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Container(
                    height: 80 * heightFraction,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: isHighlight
                            ? [AppColors.amber, AppColors.amber.withOpacity(0.6)]
                            : [
                                AppColors.teal.withOpacity(0.6),
                                AppColors.blue.withOpacity(0.4)
                              ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: List.generate(labels.length, (i) {
            final isHighlight = i == highlightIndex;
            return Expanded(
              child: Text(
                labels[i],
                textAlign: TextAlign.center,
                style: AppText.dm(
                  size: 10,
                  color: isHighlight ? AppColors.amber : AppColors.muted,
                  weight: isHighlight ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _VehicleReportRow extends StatelessWidget {
  final Vehicle vehicle;

  const _VehicleReportRow({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final pct = (vehicle.mileage / 50000).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.navy2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(vehicle.icon, size: 18, color: AppColors.muted),
              const SizedBox(width: 8),
              Expanded(
                child: Text(vehicle.name,
                    style: AppText.dm(size: 13, weight: FontWeight.w600)),
              ),
              Text('${vehicle.mileage ~/ 1000}k km',
                  style: AppText.syne(size: 13, color: AppColors.teal)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: AppColors.navy3,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.teal),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(vehicle.plate, style: AppText.mono(size: 10)),
              Text('${(pct * 100).toInt()}% of target',
                  style: AppText.dm(size: 10, color: AppColors.muted)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TripReportRow extends StatelessWidget {
  final TripRecord trip;

  const _TripReportRow({required this.trip});

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
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppColors.teal.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.route_rounded,
                size: 18, color: AppColors.teal),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${trip.distanceKm.toInt()} km · ${trip.durationHrs.floor()}h ${((trip.durationHrs % 1) * 60).toInt()}m',
                    style: AppText.dm(size: 13, weight: FontWeight.w600)),
                Text('${trip.origin} → ${trip.destination}',
                    style: AppText.dm(size: 11, color: AppColors.muted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Text('${trip.startTime}',
              style: AppText.mono(size: 11)),
        ],
      ),
    );
  }
}
