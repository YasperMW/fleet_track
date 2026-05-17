import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'map_screen.dart';
import 'fleet_screen.dart';
import 'alerts_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';
import '../widgets/shared_widgets.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final _screens = const [
    MapScreen(),
    FleetScreen(),
    AlertsScreen(),
    ReportsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: FleetBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
