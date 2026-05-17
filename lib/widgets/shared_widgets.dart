import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

// ─── BOTTOM NAV BAR ─────────────────────────────────────────────────
class FleetBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FleetBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.map_rounded, Icons.map_rounded, 'Map'),
      (Icons.directions_car_outlined, Icons.directions_car_rounded, 'Fleet'),
      (Icons.notifications_outlined, Icons.notifications_rounded, 'Alerts'),
      (Icons.bar_chart_rounded, Icons.bar_chart_rounded, 'Reports'),
      (Icons.settings_outlined, Icons.settings_rounded, 'Settings'),
    ];

    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Color(0xF70B1628),
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: List.generate(items.length, (i) {
          final isActive = i == currentIndex;
          final item = items[i];
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      if (isActive)
                        Container(
                          width: 48,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.teal.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      Icon(
                        isActive ? item.$2 : item.$1,
                        size: 22,
                        color: isActive ? AppColors.teal : AppColors.muted,
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.$3,
                    style: AppText.dm(
                      size: 9,
                      color: isActive ? AppColors.teal : AppColors.muted,
                      weight: isActive ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─── STATUS TAG ─────────────────────────────────────────────────────
class StatusTag extends StatelessWidget {
  final VehicleStatus status;

  const StatusTag({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    String symbol;

    switch (status) {
      case VehicleStatus.moving:
        color = AppColors.teal;
        label = 'Moving';
        symbol = '▶';
      case VehicleStatus.parked:
        color = AppColors.muted;
        label = 'Parked';
        symbol = '■';
      case VehicleStatus.alert:
        color = AppColors.red;
        label = 'Alert';
        symbol = '⚠';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        '$symbol $label',
        style: AppText.dm(size: 10, color: color, weight: FontWeight.w600),
      ),
    );
  }
}

// ─── ALERT SEVERITY TAG ─────────────────────────────────────────────
class SeverityTag extends StatelessWidget {
  final AlertSeverity severity;

  const SeverityTag({super.key, required this.severity});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    IconData icon;

    switch (severity) {
      case AlertSeverity.critical:
        color = AppColors.red;
        label = 'Critical';
        icon = Icons.warning_rounded;
      case AlertSeverity.warning:
        color = AppColors.amber;
        label = 'Warning';
        icon = Icons.error_outline_rounded;
      case AlertSeverity.info:
        color = AppColors.blue;
        label = 'Info';
        icon = Icons.info_outline_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label, style: AppText.dm(size: 10, color: color, weight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ─── FLEET CARD ─────────────────────────────────────────────────────
class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback? onTap;

  const VehicleCard({super.key, required this.vehicle, this.onTap});

  Color get _iconBg {
    switch (vehicle.status) {
      case VehicleStatus.moving:
        return AppColors.teal.withOpacity(0.15);
      case VehicleStatus.parked:
        return AppColors.muted.withOpacity(0.12);
      case VehicleStatus.alert:
        return AppColors.red.withOpacity(0.12);
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
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(vehicle.icon, color: _iconColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vehicle.name,
                      style: AppText.dm(size: 14, weight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(vehicle.plate,
                      style: AppText.mono(size: 11)),
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
                        : AppColors.muted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── ALERT BANNER ───────────────────────────────────────────────────
class AlertBanner extends StatelessWidget {
  final AlertItem alert;
  final VoidCallback? onTap;

  const AlertBanner({super.key, required this.alert, this.onTap});

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _color.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Icon(_icon, color: _color, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(alert.title,
                      style: AppText.dm(size: 12, color: _color, weight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(alert.message,
                      style: AppText.dm(size: 11, color: AppColors.text2)),
                ],
              ),
            ),
            if (onTap != null)
              Icon(Icons.chevron_right_rounded, color: _color, size: 20),
          ],
        ),
      ),
    );
  }
}

// ─── SECTION HEADER ─────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String label;
  final Widget? trailing;

  const SectionHeader({super.key, required this.label, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            label.toUpperCase(),
            style: AppText.dm(
              size: 11,
              color: AppColors.muted,
              weight: FontWeight.w600,
            ).copyWith(letterSpacing: 0.5),
          ),
          if (trailing != null) ...[
            const Spacer(),
            trailing!,
          ],
        ],
      ),
    );
  }
}

// ─── STAT CARD ──────────────────────────────────────────────────────
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? sub;
  final Color? valueColor;
  final Color? bgColor;
  final Color? borderColor;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.sub,
    this.valueColor,
    this.bgColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor ?? AppColors.navy2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor ?? AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppText.dm(size: 11, color: valueColor ?? AppColors.muted)),
          const SizedBox(height: 6),
          Text(value,
              style: AppText.syne(
                  size: 30, color: valueColor ?? AppColors.text, weight: FontWeight.w800)),
          if (sub != null) ...[
            const SizedBox(height: 2),
            Text(sub!, style: AppText.dm(size: 12, color: AppColors.text2)),
          ],
        ],
      ),
    );
  }
}

// ─── SETTINGS ROW ───────────────────────────────────────────────────
class SettingsRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsRow({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.dm(size: 14, weight: FontWeight.w500)),
                  if (subtitle != null)
                    Text(subtitle!,
                        style: AppText.dm(size: 12, color: AppColors.muted)),
                ],
              ),
            ),
            trailing ??
                Icon(Icons.chevron_right_rounded,
                    color: AppColors.muted, size: 20),
          ],
        ),
      ),
    );
  }
}

// ─── USER AVATAR ────────────────────────────────────────────────────
class UserAvatar extends StatelessWidget {
  final String initials;
  final Color color;
  final double size;

  const UserAvatar({
    super.key,
    required this.initials,
    required this.color,
    this.size = 38,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, color.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(size / 3),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: AppText.dm(
          size: size * 0.34,
          color: Colors.white,
          weight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ─── MAP MOCK WIDGET ────────────────────────────────────────────────
class MapMock extends StatelessWidget {
  final double height;
  final BorderRadius? borderRadius;

  const MapMock({super.key, this.height = 200, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(14),
      child: Container(
        height: height,
        color: const Color(0xFF0E1E38),
        child: Stack(
          children: [
            // Grid
            CustomPaint(
              size: Size.infinite,
              painter: _MapGridPainter(),
            ),
            // Roads H
            Positioned(
              top: height * 0.45,
              left: 0,
              right: 0,
              child: Container(height: 5, color: AppColors.blue.withOpacity(0.2)),
            ),
            Positioned(
              top: height * 0.65,
              left: 0,
              right: 0,
              child: Container(height: 8, color: AppColors.blue.withOpacity(0.25)),
            ),
            // Roads V
            Positioned(
              left: MediaQuery.of(context).size.width * 0.3,
              top: 0,
              bottom: 0,
              child: Container(width: 5, color: AppColors.blue.withOpacity(0.2)),
            ),
            // Vehicle dots
            Positioned(
              top: height * 0.3,
              left: MediaQuery.of(context).size.width * 0.25,
              child: _VehicleDot(color: AppColors.teal, label: '▶'),
            ),
            Positioned(
              top: height * 0.55,
              left: MediaQuery.of(context).size.width * 0.55,
              child: _VehicleDot(color: AppColors.muted, label: '■'),
            ),
            Positioned(
              top: height * 0.2,
              left: MediaQuery.of(context).size.width * 0.6,
              child: _VehicleDot(color: AppColors.red, label: '⚠'),
            ),
          ],
        ),
      ),
    );
  }
}

class _VehicleDot extends StatelessWidget {
  final Color color;
  final String label;

  const _VehicleDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.7), width: 2),
        boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, spreadRadius: 2)],
      ),
      alignment: Alignment.center,
      child: Text(label, style: const TextStyle(fontSize: 7, color: Colors.white)),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.blue.withOpacity(0.05)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += 22) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 22) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.blue.withOpacity(0.05)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += 22) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 22) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─── TEAL BUTTON ────────────────────────────────────────────────────
class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool fullWidth;

  const PrimaryButton({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.teal, AppColors.blue],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: Colors.black),
              const SizedBox(width: 8),
            ],
            Text(label,
                style: AppText.dm(
                    size: 14, color: Colors.black, weight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

// ─── SEARCH INPUT ───────────────────────────────────────────────────
class SearchInput extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const SearchInput({super.key, required this.hint, this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.navy2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: AppColors.muted, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
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
