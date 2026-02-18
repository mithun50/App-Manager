import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_management/providers/usage_provider.dart';
import 'package:app_management/providers/category_provider.dart';
import 'package:app_management/providers/settings_provider.dart';
import 'package:app_management/services/database_service.dart';
import 'package:app_management/services/notification_service.dart';
import 'package:app_management/services/background_service.dart';
import 'package:app_management/screens/home_screen.dart';
import 'package:app_management/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseService.instance.database;
  await NotificationService.instance.init();
  BackgroundService.instance.init();

  runApp(const AppManagement());
}

class AppManagement extends StatelessWidget {
  const AppManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()..loadCategories()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()..loadSettings()),
        ChangeNotifierProxyProvider<CategoryProvider, UsageProvider>(
          create: (_) => UsageProvider(),
          update: (_, categoryProvider, usageProvider) {
            usageProvider!.setCategoryProvider(categoryProvider);
            return usageProvider;
          },
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'App Manager',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
