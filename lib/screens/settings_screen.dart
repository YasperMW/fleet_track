import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _api = ApiService();

  bool _pushAlerts = true;
  bool _speedAlerts = true;
  bool _emailReports = false;
  int _updateInterval = 5;
  String _geofencePrecision = 'high';
  Map<String, dynamic>? _user;

  @override
  void initState() {
    super.initState();
    _fetchAll();
  }

  Future<void> _fetchAll() async {
    try {
      final results = await Future.wait([
        _api.getCurrentUser(),
        _api.getPreferences(),
      ]);
      if (!mounted) return;
      final prefs = results[1];
      setState(() {
        _user = results[0];
        _pushAlerts = prefs['push_alerts'] ?? true;
        _speedAlerts = prefs['speed_alerts'] ?? true;
        _emailReports = prefs['email_reports'] ?? false;
        _updateInterval = prefs['update_interval'] ?? 5;
        _geofencePrecision = prefs['geofence_precision'] ?? 'high';
      });
    } catch (_) {}
  }

  Future<void> _updatePref(String field, dynamic value) async {
    try {
      await _api.updatePreferences({field: value});
    } catch (_) {}
  }

  void _showIntervalPicker() {
    final options = [1, 3, 5, 10, 15, 30];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.navy2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Update Interval',
                style: AppText.syne(size: 16, color: AppColors.text)),
            const SizedBox(height: 4),
            Text('How often the GPS position refreshes',
                style: AppText.dm(size: 12, color: AppColors.muted)),
            const SizedBox(height: 16),
            ...options.map((s) => GestureDetector(
                  onTap: () {
                    setState(() => _updateInterval = s);
                    _updatePref('update_interval', s);
                    Navigator.pop(ctx);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    decoration: BoxDecoration(
                      color: _updateInterval == s
                          ? AppColors.teal.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('Every $s second${s == 1 ? '' : 's'}',
                              style: AppText.dm(
                                  size: 13,
                                  color: _updateInterval == s
                                      ? AppColors.teal
                                      : AppColors.text,
                                  weight: _updateInterval == s
                                      ? FontWeight.w600
                                      : FontWeight.w400)),
                        ),
                        if (_updateInterval == s)
                          const Icon(Icons.check_rounded,
                              size: 18, color: AppColors.teal),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _showPrecisionPicker() {
    final options = [
      ('high', 'High (±10m)', 'Best accuracy, more battery'),
      ('balanced', 'Balanced (±25m)', 'Good accuracy, optimized battery'),
      ('low', 'Low (±100m)', 'Reduced accuracy, max battery life'),
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.navy2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Geofence Precision',
                style: AppText.syne(size: 16, color: AppColors.text)),
            const SizedBox(height: 4),
            Text('Accuracy of geofence boundary detection',
                style: AppText.dm(size: 12, color: AppColors.muted)),
            const SizedBox(height: 16),
            ...options.map((o) => GestureDetector(
                  onTap: () {
                    setState(() => _geofencePrecision = o.$1);
                    _updatePref('geofence_precision', o.$1);
                    Navigator.pop(ctx);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    decoration: BoxDecoration(
                      color: _geofencePrecision == o.$1
                          ? AppColors.teal.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(o.$2,
                                  style: AppText.dm(
                                      size: 13,
                                      color: _geofencePrecision == o.$1
                                          ? AppColors.teal
                                          : AppColors.text,
                                      weight: _geofencePrecision == o.$1
                                          ? FontWeight.w600
                                          : FontWeight.w400)),
                              Text(o.$3,
                                  style: AppText.dm(
                                      size: 11, color: AppColors.muted)),
                            ],
                          ),
                        ),
                        if (_geofencePrecision == o.$1)
                          const Icon(Icons.check_rounded,
                              size: 18, color: AppColors.teal),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final name = _user?['name'] ?? 'Fleet Manager';
    final email = _user?['email'] ?? 'admin@fleet.co';
    final initials =
        name.split(' ').map((s) => s[0]).join().toUpperCase();

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
                    gradient:
                        LinearGradient(colors: [AppColors.teal, AppColors.blue]),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(initials.substring(0, 2),
                      style: AppText.dm(
                          size: 13,
                          color: Color(0xFF050C1A),
                          weight: FontWeight.w700)),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppText.syne(size: 16)),
                    Text(email,
                        style:
                            AppText.dm(size: 12, color: AppColors.teal)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 40),
              children: [
                _SettingsGroup(title: 'Notifications', children: [
                  _ToggleRow(
                      icon: Icons.notifications_active_rounded,
                      iconColor: AppColors.teal,
                      title: 'Push Alerts',
                      subtitle: 'Tamper, speed, geofence events',
                      value: _pushAlerts,
                      onChanged: (v) {
                        setState(() => _pushAlerts = v);
                        _updatePref('push_alerts', v);
                      }),
                  _ToggleRow(
                      icon: Icons.speed_rounded,
                      iconColor: AppColors.teal,
                      title: 'Speed Alerts',
                      subtitle: 'Alert when limit exceeded',
                      value: _speedAlerts,
                      onChanged: (v) {
                        setState(() => _speedAlerts = v);
                        _updatePref('speed_alerts', v);
                      }),
                  _ToggleRow(
                      icon: Icons.email_rounded,
                      iconColor: AppColors.muted,
                      title: 'Email Reports',
                      subtitle: 'Weekly summary digest',
                      value: _emailReports,
                      onChanged: (v) {
                        setState(() => _emailReports = v);
                        _updatePref('email_reports', v);
                      },
                      isLast: true),
                ]),
                const SizedBox(height: 16),
                _SettingsGroup(title: 'Tracking', children: [
                  _ArrowRow(
                      icon: Icons.location_on_rounded,
                      iconColor: AppColors.teal,
                      title: 'Update Interval',
                      subtitle: 'Every $_updateInterval second${_updateInterval == 1 ? '' : 's'}',
                      onTap: _showIntervalPicker),
                  _ArrowRow(
                      icon: Icons.fence_rounded,
                      iconColor: AppColors.teal,
                      title: 'Geofence Precision',
                      subtitle: _geofencePrecision == 'high'
                          ? 'High (±10m)'
                          : _geofencePrecision == 'balanced'
                              ? 'Balanced (±25m)'
                              : 'Low (±100m)',
                      onTap: _showPrecisionPicker,
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
                  _ArrowRow(
                    icon: Icons.security_rounded,
                    iconColor: AppColors.amber,
                    title: 'Security & 2FA',
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SecurityScreen())),
                  ),
                  _ArrowRow(
                      icon: Icons.policy_rounded,
                      iconColor: AppColors.muted,
                      title: 'Privacy Policy',
                      onTap: () => launchUrl(
                          Uri.parse('https://fleet-track.example.com/privacy'),
                          mode: LaunchMode.externalApplication),
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
  final ValueChanged<bool> onChanged;

  const _ToggleRow(
      {required this.icon,
      required this.iconColor,
      required this.title,
      required this.subtitle,
      required this.value,
      required this.onChanged,
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
  void didUpdateWidget(_ToggleRow old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) _value = widget.value;
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
            onTap: () {
              final next = !_value;
              setState(() => _value = next);
              widget.onChanged(next);
            },
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
                border:
                    Border(bottom: BorderSide(color: AppColors.border))),
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
                      style:
                          AppText.dm(size: 13, weight: FontWeight.w500)),
                  if (subtitle != null)
                    Text(subtitle!,
                        style:
                            AppText.dm(size: 11, color: AppColors.muted)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                size: 16, color: AppColors.muted),
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
                child: Text('Cancel',
                    style: AppText.dm(color: AppColors.muted))),
            TextButton(
                onPressed: () async {
                  await ApiService().logout();
                  if (!context.mounted) return;
                  Navigator.pop(ctx);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                child: Text('Sign Out',
                    style: AppText.dm(color: AppColors.red))),
          ],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: isLast
            ? null
            : const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: AppColors.border))),
        child: Row(
          children: [
            const SizedBox(
              width: 24,
              child: Icon(Icons.logout_rounded,
                  size: 20, color: AppColors.red),
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
class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final _api = ApiService();
  List<AppUser> _users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final users = await _api.getUsers();
      if (!mounted) return;
      setState(() {
        _users = users;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(e is ApiException ? e.message : 'Failed to load users'),
        backgroundColor: AppColors.red,
      ));
    }
  }

  Future<void> _inviteUser() async {
    final emailCtl = TextEditingController();
    final nameCtl = TextEditingController();
    final passwordCtl = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.navy2,
        title: const Text('Invite User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtl,
              style: AppText.dm(size: 13, color: AppColors.text),
              decoration: InputDecoration(
                labelText: 'Full name',
                labelStyle: AppText.dm(size: 12, color: AppColors.muted),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.teal),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailCtl,
              style: AppText.dm(size: 13, color: AppColors.text),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: AppText.dm(size: 12, color: AppColors.muted),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.teal),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordCtl,
              obscureText: true,
              style: AppText.dm(size: 13, color: AppColors.text),
              decoration: InputDecoration(
                labelText: 'Temporary password',
                labelStyle: AppText.dm(size: 12, color: AppColors.muted),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.teal),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: AppText.dm(color: AppColors.muted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Invite', style: AppText.dm(color: AppColors.teal)),
          ),
        ],
      ),
    );
    if (result != true) return;
    if (nameCtl.text.trim().isEmpty || emailCtl.text.trim().isEmpty || passwordCtl.text.trim().isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('All fields required'),
        backgroundColor: AppColors.red,
      ));
      return;
    }
    try {
      await _api.inviteUser(emailCtl.text.trim(), passwordCtl.text.trim(), nameCtl.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('User invited successfully'),
        backgroundColor: AppColors.teal,
      ));
      _fetch();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e is ApiException ? e.message : 'Failed to invite user'),
        backgroundColor: AppColors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final admins = _users.where((u) => u.role == 'Admin').toList();
    final managers = _users.where((u) => u.role == 'Manager').toList();
    final viewers = _users.where((u) => u.role == 'Viewer').toList();

    return Scaffold(
      backgroundColor: AppColors.navy,
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.teal))
          : Column(
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
                                style: AppText.dm(
                                    size: 13, color: AppColors.teal)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                          child:
                              Text('Users', style: AppText.syne(size: 18))),
                      GestureDetector(
                        onTap: _inviteUser,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [AppColors.teal, AppColors.blue]),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                              Row(mainAxisSize: MainAxisSize.min, children: [
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
                  size: 11,
                  color: AppColors.muted,
                  weight: FontWeight.w600)),
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 14),
                decoration: isLast
                    ? null
                    : const BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: AppColors.border))),
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
                              style: AppText.dm(
                                  size: 11, color: AppColors.muted)),
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
          style: AppText.dm(
              size: 11, color: _color, weight: FontWeight.w700)),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// SECURITY SCREEN
// ═══════════════════════════════════════════════════════════
class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Column(
        children: [
          SizedBox(height: topPad),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
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
                Text('Security & 2FA',
                    style: AppText.syne(size: 18)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 40),
              children: [
                _SettingsGroup(title: 'Authentication', children: [
                  _ToggleRow(
                      icon: Icons.phonelink_lock_rounded,
                      iconColor: AppColors.teal,
                      title: 'Two-Factor Auth',
                      subtitle: 'OTP via authenticator app',
                      value: false,
                      isLast: false,
                      onChanged: (v) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(v
                              ? '2FA enabled — configure your authenticator app'
                              : '2FA disabled'),
                          backgroundColor: AppColors.teal,
                        ));
                      }),
                  _ToggleRow(
                      icon: Icons.fingerprint_rounded,
                      iconColor: AppColors.teal,
                      title: 'Biometric Login',
                      subtitle: 'Fingerprint / Face ID',
                      value: false,
                      isLast: true,
                      onChanged: (v) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              v ? 'Biometric login enabled' : 'Biometric login disabled'),
                          backgroundColor: AppColors.teal,
                        ));
                      }),
                ]),
                const SizedBox(height: 16),
                _SettingsGroup(title: 'Session', children: [
                  const _InfoRow(
                      icon: Icons.timer_rounded,
                      iconColor: AppColors.muted,
                      title: 'Session Timeout',
                      subtitle: '30 minutes of inactivity'),
                  _ArrowRow(
                      icon: Icons.devices_rounded,
                      iconColor: AppColors.muted,
                      title: 'Active Sessions',
                      subtitle: '1 device · This device',
                      isLast: true,
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('No other active sessions'),
                                backgroundColor: AppColors.teal),
                          )),
                ]),
                const SizedBox(height: 16),
                _SettingsGroup(title: 'Password', children: [
                  _ArrowRow(
                      icon: Icons.lock_reset_rounded,
                      iconColor: AppColors.amber,
                      title: 'Change Password',
                      isLast: true,
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Password change dialog'),
                                backgroundColor: AppColors.teal),
                          )),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
