import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import 'vehicle_detail_screen.dart';

class FleetScreen extends StatefulWidget {
  const FleetScreen({super.key});

  @override
  State<FleetScreen> createState() => _FleetScreenState();
}

class _FleetScreenState extends State<FleetScreen> {
  final _api = ApiService();
  int _filterIndex = 0;
  final _searchController = TextEditingController();
  List<Vehicle> _vehicles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
    _searchController.addListener(() => setState(() {}));
  }

  Future<void> _fetchVehicles() async {
    try {
      final vehicles = await _api.getVehicles();
      if (!mounted) return;
      setState(() {
        _vehicles = vehicles;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e is ApiException ? e.message : 'Failed to load vehicles'),
        backgroundColor: AppColors.red,
      ));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Vehicle> get _filtered {
    final q = _searchController.text.trim().toLowerCase();
    var list = _vehicles;
    if (q.isNotEmpty) {
      list = list.where((v) =>
          v.name.toLowerCase().contains(q) ||
          v.plate.toLowerCase().contains(q) ||
          v.location.toLowerCase().contains(q)).toList();
    }
    if (_filterIndex == 1) {
      return list.where((v) => v.status == VehicleStatus.moving).toList();
    } else if (_filterIndex == 2) {
      return list.where((v) => v.status == VehicleStatus.alert).toList();
    }
    return list;
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
      floatingActionButton: FloatingActionButton(
              onPressed: _openAddVehicle,
              backgroundColor: AppColors.teal,
              foregroundColor: const Color(0xFF050C1A),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.add_rounded, size: 22),
            ),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Fleet', style: AppText.syne(size: 18)),
                      Text(
                        '${_vehicles.length} vehicles · ${_vehicles.where((v) => v.status == VehicleStatus.alert).length} alert',
                        style: AppText.dm(size: 11, color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
                      label: 'All (${_vehicles.length})',
                      active: _filterIndex == 0,
                      onTap: () => setState(() => _filterIndex = 0)),
                  const SizedBox(width: 6),
                  _FilterChip(
                      label: 'Moving (${_vehicles.where((v) => v.status == VehicleStatus.moving).length})',
                      active: _filterIndex == 1,
                      onTap: () => setState(() => _filterIndex = 1)),
                  const SizedBox(width: 6),
                  _FilterChip(
                      label: 'Alert (${_vehicles.where((v) => v.status == VehicleStatus.alert).length})',
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

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _api = ApiService();
  bool _saving = false;
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

  Future<void> _submit() async {
    if (_plateController.text.trim().isEmpty || _modelController.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      await _api.createVehicle({
        'name': _modelController.text.trim(),
        'plate': _plateController.text.trim().toUpperCase(),
        'mileage': 0,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Vehicle added'),
        backgroundColor: AppColors.teal,
      ));
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e is ApiException ? e.message : 'Failed to add vehicle'),
        backgroundColor: AppColors.red,
      ));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
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
                    label: _saving ? 'Saving\u2026' : 'Add Vehicle',
                    icon: Icons.add_circle_outline_rounded,
                    onTap: _saving ? null : _submit,
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
