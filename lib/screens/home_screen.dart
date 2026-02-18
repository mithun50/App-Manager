import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_management/providers/usage_provider.dart';
import 'package:app_management/screens/dashboard/dashboard_screen.dart';
import 'package:app_management/screens/categories/categories_screen.dart';
import 'package:app_management/screens/limits/limits_screen.dart';
import 'package:app_management/screens/settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _currentIndex = 0;

  final _screens = const [
    DashboardScreen(),
    CategoriesScreen(),
    LimitsScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final usageProvider = context.read<UsageProvider>();
    usageProvider.checkPermission().then((_) {
      if (usageProvider.hasPermission) {
        usageProvider.startPolling();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final usageProvider = context.read<UsageProvider>();
    if (state == AppLifecycleState.resumed) {
      usageProvider.checkPermission().then((_) {
        if (usageProvider.hasPermission) {
          usageProvider.startPolling();
        }
      });
    } else if (state == AppLifecycleState.paused) {
      usageProvider.stopPolling();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category),
            label: 'Categories',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer),
            label: 'Limits',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
