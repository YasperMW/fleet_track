import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import 'login_screen.dart';

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
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [AppColors.teal, AppColors.blue]),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text('FM',
                      style: AppText.dm(
                          size: 13,
                          color: const Color(0xFF050C1A),
                          weight: FontWeight.w700)),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fleet Manager', style: AppText.syne(size: 16)),
                    Text('admin@fleet.co',
                        style: AppText.dm(size: 12, color: AppColors.teal)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 40),
              children: [
                const _SettingsGroup(title: 'Notifications', children: [
                  _ToggleRow(
                      icon: Icons.notifications_active_rounded,
                      iconColor: AppColors.teal,
                      title: 'Push Alerts',
                      subtitle: 'Tamper, speed, geofence events',
                      value: true),
                  _ToggleRow(
                      icon: Icons.speed_rounded,
                      iconColor: AppColors.teal,
                      title: 'Speed Alerts',
                      subtitle: 'Alert when limit exceeded',
                      value: true),
                  _ToggleRow(
                      icon: Icons.email_rounded,
                      iconColor: AppColors.muted,
                      title: 'Email Reports',
                      subtitle: 'Weekly summary digest',
                      value: false,
                      isLast: true),
                ]),
                const SizedBox(height: 16),
                const _SettingsGroup(title: 'Tracking', children: [
                  _ArrowRow(
                      icon: Icons.location_on_rounded,
                      iconColor: AppColors.teal,
                      title: 'Update Interval',
                      subtitle: 'Every 5 seconds'),
                  _ArrowRow(
                      icon: Icons.fence_rounded,
                      iconColor: AppColors.teal,
                      title: 'Geofence Precision',
                      subtitle: 'High (±10m)',
                      isLast: true),
                ]),
                const SizedBox(height: 16),
                _SettingsGroup(title: 'Account', children: [
                  _ArrowRow(
                    icon: Icons.manage_accounts_rounded,
                    iconColor: AppColors.blue,
                    title: 'User Management',
                    subtitle: 'Admins, managers, viewers',
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const UserManagementScreen())),
                  ),
                  const _ArrowRow(
                      icon: Icons.security_rounded,
                      iconColor: AppColors.amber,
                      title: 'Security & 2FA'),
                  const _ArrowRow(
                      icon: Icons.policy_rounded,
                      iconColor: AppColors.muted,
                      title: 'Privacy Policy',
                      isLast: true),
                ]),
                const SizedBox(height: 16),
                const _SettingsGroup(title: 'About', children: [
                  _InfoRow(
                      icon: Icons.smartphone_rounded,
                      iconColor: AppColors.muted,
                      title: 'App Version',
                      subtitle: 'FleetTrack v1.0.0'),
                  _SignOutRow(isLast: true),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SettingsGroup({required this.title, required this.children});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 8),
          child: Text(title.toUpperCase(),
              style: AppText.dm(
                  size: 11, color: AppColors.muted, weight: FontWeight.w600)),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.navy2,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _ToggleRow extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final String title, subtitle;
  final bool value;
  final bool isLast;

  const _ToggleRow(
      {required this.icon,
      required this.iconColor,
      required this.title,
      required this.subtitle,
      required this.value,
      this.isLast = false});

  @override
  State<_ToggleRow> createState() => _ToggleRowState();
}

class _ToggleRowState extends State<_ToggleRow> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: widget.isLast
          ? null
          : const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border))),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Icon(widget.icon, size: 20, color: widget.iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title,
                    style: AppText.dm(size: 13, weight: FontWeight.w500)),
                Text(widget.subtitle,
                    style: AppText.dm(size: 11, color: AppColors.muted)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _value = !_value),
            child: Container(
              width: 36,
              height: 20,
              decoration: BoxDecoration(
                color: _value ? AppColors.teal : AppColors.navy3,
                borderRadius: BorderRadius.circular(12),
                border: _value
                    ? null
                    : Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment:
                    _value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 14,
                  height: 14,
                  margin: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArrowRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final bool isLast;
  final VoidCallback? onTap;

  const _ArrowRow(
      {required this.icon,
      required this.iconColor,
      required this.title,
      this.subtitle,
      this.isLast = false,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: isLast
            ? null
            : const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border))),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppText.dm(size: 13, weight: FontWeight.w500)),
                  if (subtitle != null)
                    Text(subtitle!,
                        style: AppText.dm(size: 11, color: AppColors.muted)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.muted),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title, subtitle;

  const _InfoRow(
      {required this.icon,
      required this.iconColor,
      required this.title,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppText.dm(size: 13, weight: FontWeight.w500)),
                Text(subtitle,
                    style: AppText.dm(size: 11, color: AppColors.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SignOutRow extends StatelessWidget {
  final bool isLast;
  const _SignOutRow({this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.navy2,
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child:
                    Text('Cancel', style: AppText.dm(color: AppColors.muted))),
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                child:
                    Text('Sign Out', style: AppText.dm(color: AppColors.red))),
          ],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: isLast
            ? null
            : const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border))),
        child: Row(
          children: [
            const SizedBox(
              width: 24,
              child: Icon(Icons.logout_rounded, size: 20, color: AppColors.red),
            ),
            const SizedBox(width: 12),
            Text('Sign Out',
                style: AppText.dm(
                    size: 13, color: AppColors.red, weight: FontWeight.w500)),
          ],
        ),
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
    final admins = SampleData.users.where((u) => u.role == 'Admin').toList();
    final managers =
        SampleData.users.where((u) => u.role == 'Manager').toList();
    final viewers = SampleData.users.where((u) => u.role == 'Viewer').toList();

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
                Expanded(child: Text('Users', style: AppText.syne(size: 18))),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [AppColors.teal, AppColors.blue]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.person_add_rounded,
                        size: 16, color: Color(0xFF050C1A)),
                    const SizedBox(width: 4),
                    Text('Invite',
                        style: AppText.dm(
                            size: 13,
                            color: const Color(0xFF050C1A),
                            weight: FontWeight.w700)),
                  ]),
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
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.teal.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.teal.withValues(alpha: 0.2),
                        style: BorderStyle.solid),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.mail_rounded, size: 20, color: AppColors.teal),
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
                              behavior: SnackBarBehavior.floating),
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
          padding: const EdgeInsets.only(left: 2, bottom: 8),
          child: Text(title.toUpperCase(),
              style: AppText.dm(
                  size: 11, color: AppColors.muted, weight: FontWeight.w600)),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.navy2,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: users.map((u) {
              final isLast = users.last == u;
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: isLast
                    ? null
                    : const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: AppColors.border))),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          u.avatarColor,
                          u.avatarColor.withValues(alpha: 0.7)
                        ]),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(u.initials,
                          style: AppText.dm(
                              size: 11,
                              color: const Color(0xFF050C1A),
                              weight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(u.name,
                              style: AppText.dm(
                                  size: 13, weight: FontWeight.w500)),
                          Text(u.email,
                              style:
                                  AppText.dm(size: 11, color: AppColors.muted)),
                        ],
                      ),
                    ),
                    _RoleTag(role: u.role),
                  ],
                ),
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
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withValues(alpha: 0.25)),
      ),
      child: Text(role,
          style: AppText.dm(size: 11, color: _color, weight: FontWeight.w700)),
    );
  }
}
