import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/shared_widgets.dart';

// ═══════════════════════════════════════════════════════════
// SETTINGS MAIN SCREEN
// ═══════════════════════════════════════════════════════════
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                Expanded(child: Text('Settings', style: AppText.syne(size: 18))),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 40),
              children: [
                // Profile card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.teal.withOpacity(0.1),
                        AppColors.blue.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: AppColors.teal.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const UserAvatar(
                          initials: 'FM',
                          color: AppColors.teal,
                          size: 52),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Fleet Manager',
                                style: AppText.syne(size: 16)),
                            Text('admin@fleet.co',
                                style: AppText.dm(
                                    size: 12, color: AppColors.muted)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.teal.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: AppColors.teal.withOpacity(0.25)),
                              ),
                              child: Text('Admin',
                                  style: AppText.dm(
                                      size: 10,
                                      color: AppColors.teal,
                                      weight: FontWeight.w700)),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.edit_rounded,
                          color: AppColors.muted, size: 18),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                _SettingsSection(
                  title: 'Fleet',
                  children: [
                    SettingsRow(
                      icon: Icons.notifications_rounded,
                      iconColor: AppColors.amber,
                      title: 'Notifications',
                      subtitle: 'Alerts, speed, geofence',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const NotificationsSettingsScreen()),
                      ),
                    ),
                    const Divider(color: AppColors.border, height: 1, indent: 62),
                    SettingsRow(
                      icon: Icons.fence_rounded,
                      iconColor: AppColors.blue,
                      title: 'Geofences',
                      subtitle: '3 zones configured',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const _SettingsDetailScreen(title: 'Geofences')),
                      ),
                    ),
                    const Divider(color: AppColors.border, height: 1, indent: 62),
                    SettingsRow(
                      icon: Icons.speed_rounded,
                      iconColor: AppColors.teal,
                      title: 'Speed Limits',
                      subtitle: 'Global default: 80 km/h',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const _SettingsDetailScreen(title: 'Speed Limits')),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _SettingsSection(
                  title: 'Account',
                  children: [
                    SettingsRow(
                      icon: Icons.people_rounded,
                      iconColor: AppColors.blue,
                      title: 'Users & Permissions',
                      subtitle: '4 members',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const UserManagementScreen()),
                      ),
                    ),
                    const Divider(color: AppColors.border, height: 1, indent: 62),
                    SettingsRow(
                      icon: Icons.business_rounded,
                      iconColor: AppColors.muted,
                      title: 'Organisation',
                      subtitle: 'FleetCo Ltd · Lilongwe',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const _SettingsDetailScreen(title: 'Organisation')),
                      ),
                    ),
                    const Divider(color: AppColors.border, height: 1, indent: 62),
                    SettingsRow(
                      icon: Icons.lock_rounded,
                      iconColor: AppColors.amber,
                      title: 'Security',
                      subtitle: '2FA enabled',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const _SettingsDetailScreen(title: 'Security')),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _SettingsSection(
                  title: 'App',
                  children: [
                    SettingsRow(
                      icon: Icons.palette_rounded,
                      iconColor: AppColors.blue,
                      title: 'Appearance',
                      subtitle: 'Dark mode',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const _SettingsDetailScreen(title: 'Appearance')),
                      ),
                    ),
                    const Divider(color: AppColors.border, height: 1, indent: 62),
                    SettingsRow(
                      icon: Icons.language_rounded,
                      iconColor: AppColors.teal,
                      title: 'Language & Region',
                      subtitle: 'English · Malawian Kwacha',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const _SettingsDetailScreen(title: 'Language & Region')),
                      ),
                    ),
                    const Divider(color: AppColors.border, height: 1, indent: 62),
                    SettingsRow(
                      icon: Icons.help_outline_rounded,
                      iconColor: AppColors.muted,
                      title: 'Help & Support',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const _SettingsDetailScreen(title: 'Help & Support')),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Sign out
                GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: AppColors.navy2,
                      title: const Text('Sign Out'),
                      content: const Text('Are you sure you want to sign out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text('Cancel', style: AppText.dm(color: AppColors.muted)),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text('Sign Out', style: AppText.dm(color: AppColors.red)),
                        ),
                      ],
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.red.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: AppColors.red.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.red.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.logout_rounded,
                              color: AppColors.red, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Text('Sign Out',
                            style: AppText.dm(
                                size: 14,
                                color: AppColors.red,
                                weight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Center(
                  child: Text('FleetTrack v1.0.0 · ${SampleData.vehicles.length} vehicles',
                      style: AppText.mono(size: 10)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: AppText.dm(size: 11, color: AppColors.muted, weight: FontWeight.w600)
                .copyWith(letterSpacing: 0.5),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.navy2,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════
// NOTIFICATIONS SETTINGS SCREEN
// ═══════════════════════════════════════════════════════════
class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  bool _speedAlerts = true;
  bool _geofenceAlerts = true;
  bool _tamperAlerts = true;
  bool _lowBattery = false;
  bool _tripStart = true;
  bool _tripEnd = false;

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
                      Text('Settings',
                          style: AppText.dm(size: 13, color: AppColors.teal)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text('Notifications', style: AppText.syne(size: 18)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 40),
              children: [
                _ToggleSection(
                  title: 'Safety Alerts',
                  children: [
                    _ToggleRow(
                      label: 'Speed limit exceeded',
                      sub: 'Alert when over threshold',
                      value: _speedAlerts,
                      onChanged: (v) =>
                          setState(() => _speedAlerts = v),
                    ),
                    _ToggleRow(
                      label: 'Tamper detection',
                      sub: 'Device opened or removed',
                      value: _tamperAlerts,
                      onChanged: (v) =>
                          setState(() => _tamperAlerts = v),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _ToggleSection(
                  title: 'Geofences',
                  children: [
                    _ToggleRow(
                      label: 'Zone entry / exit',
                      sub: 'When vehicle crosses a geofence',
                      value: _geofenceAlerts,
                      onChanged: (v) =>
                          setState(() => _geofenceAlerts = v),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _ToggleSection(
                  title: 'Vehicle Events',
                  children: [
                    _ToggleRow(
                      label: 'Trip started',
                      sub: 'When ignition turns on',
                      value: _tripStart,
                      onChanged: (v) =>
                          setState(() => _tripStart = v),
                    ),
                    _ToggleRow(
                      label: 'Trip ended',
                      sub: 'When ignition turns off',
                      value: _tripEnd,
                      onChanged: (v) =>
                          setState(() => _tripEnd = v),
                    ),
                    _ToggleRow(
                      label: 'Low GPS battery',
                      sub: 'Below 20%',
                      value: _lowBattery,
                      onChanged: (v) =>
                          setState(() => _lowBattery = v),
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

class _ToggleSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _ToggleSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: AppText.dm(size: 11, color: AppColors.muted, weight: FontWeight.w600)
                .copyWith(letterSpacing: 0.5),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.navy2,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final String sub;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.label,
    required this.sub,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: AppText.dm(size: 14, weight: FontWeight.w500)),
                Text(sub,
                    style: AppText.dm(size: 12, color: AppColors.muted)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.teal,
            activeTrackColor: AppColors.teal.withOpacity(0.25),
            inactiveTrackColor: AppColors.navy3,
            inactiveThumbColor: AppColors.muted,
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// USER MANAGEMENT SCREEN
// ═══════════════════════════════════════════════════════════
class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final admins =
        SampleData.users.where((u) => u.role == 'Admin').toList();
    final managers =
        SampleData.users.where((u) => u.role == 'Manager').toList();
    final viewers =
        SampleData.users.where((u) => u.role == 'Viewer').toList();

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
                      Text('Settings',
                          style: AppText.dm(size: 13, color: AppColors.teal)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                    child: Text('Users', style: AppText.syne(size: 18))),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [AppColors.teal, AppColors.blue]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.person_add_rounded,
                          size: 16, color: Colors.black),
                      const SizedBox(width: 6),
                      Text('Invite',
                          style: AppText.dm(
                              size: 13,
                              color: Colors.black,
                              weight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 40),
              children: [
                _UserGroup(title: 'Administrators', users: admins),
                const SizedBox(height: 16),
                _UserGroup(title: 'Managers', users: managers),
                const SizedBox(height: 16),
                _UserGroup(title: 'Viewers', users: viewers),
                const SizedBox(height: 16),
                // Pending invite
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.teal.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.teal.withOpacity(0.2),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.mail_rounded,
                          color: AppColors.teal, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Pending Invite',
                                style: AppText.dm(
                                    size: 13, weight: FontWeight.w600)),
                            Text('ops@fleet.co · sent 2h ago',
                                style: AppText.dm(
                                    size: 11, color: AppColors.muted)),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Invite cancelled'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.close_rounded,
                              color: AppColors.red, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserGroup extends StatelessWidget {
  final String title;
  final List<AppUser> users;

  const _UserGroup({required this.title, required this.users});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: AppText.dm(size: 11, color: AppColors.muted, weight: FontWeight.w600)
                .copyWith(letterSpacing: 0.5),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.navy2,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: users.asMap().entries.map((entry) {
              final i = entry.key;
              final u = entry.value;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        UserAvatar(initials: u.initials, color: u.avatarColor),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(u.name,
                                  style: AppText.dm(
                                      size: 14, weight: FontWeight.w500)),
                              Text(u.email,
                                  style: AppText.dm(
                                      size: 12, color: AppColors.muted)),
                            ],
                          ),
                        ),
                        _RoleTag(role: u.role),
                      ],
                    ),
                  ),
                  if (i < users.length - 1)
                    const Divider(
                        color: AppColors.border, height: 1, indent: 62),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _RoleTag extends StatelessWidget {
  final String role;

  const _RoleTag({required this.role});

  Color get _color {
    switch (role) {
      case 'Admin':
        return AppColors.teal;
      case 'Manager':
        return AppColors.blue;
      default:
        return AppColors.muted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withOpacity(0.25)),
      ),
      child: Text(role,
          style: AppText.dm(size: 11, color: _color, weight: FontWeight.w700)),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// GENERIC SETTINGS DETAIL SCREEN
// ═══════════════════════════════════════════════════════════
class _SettingsDetailScreen extends StatelessWidget {
  final String title;

  const _SettingsDetailScreen({required this.title});

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
                      Text('Settings',
                          style: AppText.dm(size: 13, color: AppColors.teal)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(title, style: AppText.syne(size: 18)),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.teal.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.construction_rounded,
                        size: 32, color: AppColors.teal),
                  ),
                  const SizedBox(height: 16),
                  Text(title,
                      style: AppText.syne(size: 16),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text('Coming soon',
                      style: AppText.dm(size: 13, color: AppColors.muted)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
