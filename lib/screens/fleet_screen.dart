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
  int _filterIndex = 0; // 0=All, 1=Moving, 2=Alert
  bool _isEmpty = false;

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
      context,
      MaterialPageRoute(builder: (_) => const AddVehicleScreen()),
    );
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
              foregroundColor: Colors.black,
              child: const Icon(Icons.add_rounded, size: 26),
            ),
      body: Column(
        children: [
          SizedBox(height: topPad),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
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
                GestureDetector(
                  onTap: () => setState(() => _isEmpty = !_isEmpty),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.navy3,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(Icons.tune_rounded,
                        size: 20, color: AppColors.muted),
                  ),
                ),
              ],
            ),
          ),

          if (_isEmpty) ...[
            Expanded(child: _EmptyState(onAdd: _openAddVehicle)),
          ] else ...[
            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: SearchInput(hint: 'Search fleet…'),
            ),
            const SizedBox(height: 10),
            // Filter chips
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
            // Vehicle list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 100),
                children: [
                  ..._filtered.map(
                    (v) => VehicleCard(
                      vehicle: v,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                VehicleDetailScreen(vehicle: v)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _StatMini(
                          label: 'Total mileage',
                          value: '102,451',
                          sub: 'km combined',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _StatMini(
                          label: 'Today',
                          value: '247',
                          sub: 'km driven',
                          valueColor: AppColors.teal,
                        ),
                      ),
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppColors.teal : AppColors.navy3,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: active ? AppColors.teal : AppColors.border),
        ),
        child: Text(
          label,
          style: AppText.dm(
            size: 12,
            color: active ? Colors.black : AppColors.muted,
            weight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _StatMini extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
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
                color: AppColors.teal.withOpacity(0.08),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                    color: AppColors.teal.withOpacity(0.15)),
              ),
              child: Icon(Icons.directions_car_rounded,
                  size: 42, color: AppColors.teal.withOpacity(0.5)),
            ),
            const SizedBox(height: 20),
            Text('No vehicles yet',
                style: AppText.syne(size: 16),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'Add your first vehicle to start tracking\nyour fleet in real-time.',
              style: AppText.dm(size: 13, color: AppColors.muted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Add First Vehicle',
              icon: Icons.add_circle_outline_rounded,
              onTap: onAdd,
              fullWidth: false,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// ADD VEHICLE SCREEN
// ═══════════════════════════════════════════════════════════
class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  double _speedLimit = 80;
  String _selectedType = 'Van';
  final _types = ['Sedan', 'Van', 'Pickup', 'Truck', 'Bus'];

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Column(
        children: [
          SizedBox(height: topPad),
          // Header
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
                          style: AppText.dm(
                              size: 13, color: AppColors.teal)),
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
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('Vehicle Name'),
                  _TextInput(hint: 'e.g. Toyota Hiace'),
                  const SizedBox(height: 14),
                  _FieldLabel('Plate Number'),
                  _TextInput(hint: 'e.g. MWI-2341', mono: true),
                  const SizedBox(height: 14),
                  _FieldLabel('Vehicle Type'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _types.map((t) {
                      final active = t == _selectedType;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedType = t),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: active
                                ? AppColors.teal.withOpacity(0.15)
                                : AppColors.navy2,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: active
                                  ? AppColors.teal
                                  : AppColors.border,
                            ),
                          ),
                          child: Text(t,
                              style: AppText.dm(
                                size: 13,
                                color: active
                                    ? AppColors.teal
                                    : AppColors.muted,
                                weight: active
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              )),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  _FieldLabel('Device ID'),
                  _TextInput(hint: 'FT-XXXXXX', mono: true),
                  const SizedBox(height: 14),
                  _FieldLabel('Driver Name (optional)'),
                  _TextInput(hint: 'Full name'),
                  const SizedBox(height: 20),
                  // Speed limit slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Speed Limit',
                          style: AppText.dm(
                              size: 13, weight: FontWeight.w500)),
                      Text('${_speedLimit.toInt()} km/h',
                          style: AppText.mono(
                              size: 12, color: AppColors.amber)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.teal,
                      inactiveTrackColor: AppColors.navy3,
                      thumbColor: AppColors.teal,
                      overlayColor: AppColors.teal.withOpacity(0.1),
                      thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 10),
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
                        .map((l) => Text(l,
                            style: AppText.dm(
                                size: 10,
                                color: l == '80'
                                    ? AppColors.amber
                                    : AppColors.muted)))
                        .toList(),
                  ),
                  const SizedBox(height: 28),
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

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: AppText.dm(size: 12, color: AppColors.muted,
              weight: FontWeight.w600)),
    );
  }
}

class _TextInput extends StatelessWidget {
  final String hint;
  final bool mono;

  const _TextInput({required this.hint, this.mono = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.navy2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(hint,
          style: mono
              ? AppText.mono(size: 13, color: AppColors.muted)
              : AppText.dm(size: 13, color: AppColors.muted)),
    );
  }
}
