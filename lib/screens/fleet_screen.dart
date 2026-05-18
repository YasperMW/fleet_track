import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/shared_widgets.dart';
import 'vehicle_detail_screen.dart';

class FleetScreen extends StatefulWidget {
  const FleetScreen({super.key});

  @override
  State<FleetScreen> createState() => _FleetScreenState();
}

class _FleetScreenState extends State<FleetScreen> {
  int _filterIndex = 0;
  bool _isEmpty = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Vehicle> get _filtered {
    if (_filterIndex == 1) {
      return SampleData.vehicles
          .where((v) => v.status == VehicleStatus.moving)
          .toList();
    } else if (_filterIndex == 2) {
      return SampleData.vehicles
          .where((v) => v.status == VehicleStatus.alert)
          .toList();
    }
    return SampleData.vehicles;
  }

  void _openAddVehicle() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const AddVehicleScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.navy,
      floatingActionButton: _isEmpty
          ? null
          : FloatingActionButton(
              onPressed: _openAddVehicle,
              backgroundColor: AppColors.teal,
              foregroundColor: const Color(0xFF050C1A),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.add_rounded, size: 22),
            ),
      body: Column(
        children: [
          SizedBox(height: topPad),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Fleet', style: AppText.syne(size: 18)),
                      Text(
                        _isEmpty
                            ? '0 vehicles'
                            : '${SampleData.vehicles.length} vehicles · 1 alert',
                        style: AppText.dm(size: 11, color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
                Tooltip(
                  message: _isEmpty ? 'Show vehicles' : 'Toggle empty state',
                  child: GestureDetector(
                    onTap: () => setState(() => _isEmpty = !_isEmpty),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.navy3,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(Icons.tune_rounded,
                          size: 20, color: AppColors.muted),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isEmpty) ...[
            Expanded(child: _EmptyState(onAdd: _openAddVehicle)),
          ] else ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.navy3,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded,
                        size: 16,
                        color: AppColors.muted.withValues(alpha: 0.55)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: AppText.dm(size: 13, color: AppColors.text),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Search fleet\u2026',
                          hintStyle:
                              AppText.dm(size: 13, color: AppColors.muted),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 34,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                scrollDirection: Axis.horizontal,
                children: [
                  _FilterChip(
                      label: 'All (3)',
                      active: _filterIndex == 0,
                      onTap: () => setState(() => _filterIndex = 0)),
                  const SizedBox(width: 6),
                  _FilterChip(
                      label: 'Moving (1)',
                      active: _filterIndex == 1,
                      onTap: () => setState(() => _filterIndex = 1)),
                  const SizedBox(width: 6),
                  _FilterChip(
                      label: 'Alert (1)',
                      active: _filterIndex == 2,
                      onTap: () => setState(() => _filterIndex = 2)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 100),
                children: [
                  ..._filtered.map((v) => _VehicleRow(
                        vehicle: v,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => VehicleDetailScreen(vehicle: v)),
                        ),
                      )),
                  const SizedBox(height: 14),
                  const Row(
                    children: [
                      Expanded(
                          child: _StatMini(
                              label: 'Total mileage',
                              value: '102,451',
                              sub: 'km combined')),
                      SizedBox(width: 8),
                      Expanded(
                          child: _StatMini(
                              label: 'Today',
                              value: '247',
                              sub: 'km driven',
                              valueColor: AppColors.teal)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _FilterChip(
      {required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: active ? AppColors.teal : AppColors.navy3,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? AppColors.teal : AppColors.border),
        ),
        child: Text(label,
            style: AppText.dm(
                size: 12,
                color: active ? Colors.black : AppColors.muted,
                weight: FontWeight.w600)),
      ),
    );
  }
}

class _VehicleRow extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback? onTap;

  const _VehicleRow({required this.vehicle, this.onTap});

  Color get _iconBg {
    switch (vehicle.status) {
      case VehicleStatus.moving:
        return AppColors.teal.withValues(alpha: 0.12);
      case VehicleStatus.parked:
        return AppColors.muted.withValues(alpha: 0.1);
      case VehicleStatus.alert:
        return AppColors.red.withValues(alpha: 0.12);
    }
  }

  Color get _iconColor {
    switch (vehicle.status) {
      case VehicleStatus.moving:
        return AppColors.teal;
      case VehicleStatus.parked:
        return AppColors.muted;
      case VehicleStatus.alert:
        return AppColors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  color: _iconBg, borderRadius: BorderRadius.circular(10)),
              child: Icon(vehicle.icon, size: 18, color: _iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vehicle.name,
                      style: AppText.dm(size: 13, weight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Text(vehicle.plate, style: AppText.mono(size: 11)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                StatusTag(status: vehicle.status),
                const SizedBox(height: 4),
                Text(
                  vehicle.status == VehicleStatus.moving
                      ? '${vehicle.speed.toInt()} km/h'
                      : vehicle.status == VehicleStatus.alert
                          ? 'Tamper'
                          : '0 km/h',
                  style: AppText.mono(
                      size: 11,
                      color: vehicle.status == VehicleStatus.alert
                          ? AppColors.red
                          : AppColors.text2),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatMini extends StatelessWidget {
  final String label, value, sub;
  final Color? valueColor;

  const _StatMini(
      {required this.label,
      required this.value,
      required this.sub,
      this.valueColor});

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
          Text(label, style: AppText.dm(size: 11, color: AppColors.muted)),
          const SizedBox(height: 4),
          Text(value,
              style: AppText.syne(
                  size: 18,
                  color: valueColor ?? AppColors.text,
                  weight: FontWeight.w800)),
          Text(sub, style: AppText.dm(size: 11, color: AppColors.muted)),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
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
                border:
                    Border.all(color: AppColors.teal.withValues(alpha: 0.15)),
              ),
              child: Icon(Icons.directions_car_rounded,
                  size: 42, color: AppColors.teal.withValues(alpha: 0.5)),
            ),
            const SizedBox(height: 20),
            Text('No vehicles yet', style: AppText.syne(size: 16)),
            const SizedBox(height: 8),
            Text(
                'Add your first vehicle to start tracking\nyour fleet in real-time.',
                style: AppText.dm(size: 13, color: AppColors.muted),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            PrimaryButton(
                label: 'Add First Vehicle',
                icon: Icons.add_circle_outline_rounded,
                onTap: onAdd,
                fullWidth: false),
          ],
        ),
      ),
    );
  }
}

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  double _speedLimit = 80;
  final _plateController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _serialController = TextEditingController();

  @override
  void dispose() {
    _plateController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _serialController.dispose();
    super.dispose();
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
                Text('Add Vehicle', style: AppText.syne(size: 18)),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.navy3,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.teal.withValues(alpha: 0.4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Vehicle Name',
                            style: AppText.dm(
                                size: 11,
                                color: AppColors.teal,
                                weight: FontWeight.w600)),
                        const SizedBox(height: 3),
                        Text('Toyota Hiace Van',
                            style: AppText.dm(size: 14, color: AppColors.text)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _InputField(
                      icon: Icons.tag_rounded,
                      hint: 'Plate number (MWI-XXXX)',
                      controller: _plateController),
                  _InputField(
                      icon: Icons.directions_car_rounded,
                      hint: 'Make / Model',
                      controller: _modelController),
                  _InputField(
                      icon: Icons.calendar_today_rounded,
                      hint: 'Year',
                      controller: _yearController),
                  const SizedBox(height: 14),
                  Text('DEVICE PAIRING',
                      style: AppText.dm(
                          size: 11,
                          color: AppColors.muted,
                          weight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.navy2,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: AppColors.teal.withValues(alpha: 0.3),
                          style: BorderStyle.solid),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.qr_code_scanner_rounded,
                            size: 36, color: AppColors.teal),
                        const SizedBox(height: 8),
                        Text('Scan Device QR Code',
                            style:
                                AppText.dm(size: 13, weight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text('Point camera at the tracker device label',
                            style:
                                AppText.dm(size: 12, color: AppColors.muted)),
                      ],
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text('or enter device ID',
                          style: AppText.dm(
                              size: 11,
                              color: AppColors.muted,
                              weight: FontWeight.w500)),
                    ),
                  ),
                  _InputField(
                      icon: Icons.vpn_key_rounded,
                      hint: 'Device serial number',
                      controller: _serialController),
                  const SizedBox(height: 14),
                  Text('SPEED LIMIT',
                      style: AppText.dm(
                          size: 11,
                          color: AppColors.muted,
                          weight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.navy2,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text('${_speedLimit.toInt()}',
                                style: AppText.syne(
                                    size: 28,
                                    color: AppColors.amber,
                                    weight: FontWeight.w800)),
                            const SizedBox(width: 4),
                            Text('km/h',
                                style: AppText.dm(
                                    size: 12, color: AppColors.muted)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: AppColors.teal,
                            inactiveTrackColor: AppColors.navy3,
                            thumbColor: Colors.white,
                            overlayColor: AppColors.teal.withValues(alpha: 0.1),
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 9),
                            trackHeight: 4,
                          ),
                          child: Slider(
                            value: _speedLimit,
                            min: 20,
                            max: 120,
                            divisions: 10,
                            onChanged: (v) => setState(() => _speedLimit = v),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: ['20', '40', '60', '80', '100', '120']
                              .map((l) => Text(
                                    l,
                                    style: AppText.mono(
                                        size: 10,
                                        color: l == '80'
                                            ? AppColors.amber
                                            : AppColors.muted,
                                        weight: l == '80'
                                            ? FontWeight.w700
                                            : FontWeight.w400),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: 'Add Vehicle',
                    icon: Icons.add_circle_outline_rounded,
                    onTap: () => Navigator.pop(context),
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

class _InputField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final TextEditingController? controller;

  const _InputField({required this.icon, required this.hint, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.navy3,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.muted.withValues(alpha: 0.55)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              style: AppText.dm(size: 13, color: AppColors.text),
              decoration: InputDecoration.collapsed(
                hintText: hint,
                hintStyle: AppText.dm(size: 13, color: AppColors.muted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
