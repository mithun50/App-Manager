import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_management/providers/settings_provider.dart';
import 'package:app_management/providers/usage_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return ListView(
            children: [
              const _SectionHeader(title: 'Appearance'),
              ListTile(
                leading: const Icon(Icons.palette_outlined),
                title: const Text('Theme'),
                subtitle: Text(_themeName(settings.themeMode)),
                trailing: DropdownButton<ThemeMode>(
                  value: settings.themeMode,
                  underline: const SizedBox.shrink(),
                  onChanged: (mode) {
                    if (mode != null) settings.setThemeMode(mode);
                  },
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text('System'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Light'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Dark'),
                    ),
                  ],
                ),
              ),
              const Divider(),

              const _SectionHeader(title: 'Notifications'),
              SwitchListTile(
                secondary: const Icon(Icons.notifications_outlined),
                title: const Text('Usage notifications'),
                subtitle: const Text('Get notified when approaching limits'),
                value: settings.notificationsEnabled,
                onChanged: (v) => settings.setNotificationsEnabled(v),
              ),
              ListTile(
                leading: const Icon(Icons.warning_amber_outlined),
                title: const Text('Warning threshold'),
                subtitle: Text('${(settings.warningThreshold * 100).round()}% of limit'),
                trailing: SizedBox(
                  width: 150,
                  child: Slider(
                    value: settings.warningThreshold,
                    min: 0.5,
                    max: 0.95,
                    divisions: 9,
                    label: '${(settings.warningThreshold * 100).round()}%',
                    onChanged: (v) => settings.setWarningThreshold(v),
                  ),
                ),
              ),
              const Divider(),

              const _SectionHeader(title: 'Data'),
              ListTile(
                leading: const Icon(Icons.security_outlined),
                title: const Text('Usage access permission'),
                subtitle: Consumer<UsageProvider>(
                  builder: (context, usage, _) => Text(
                    usage.hasPermission ? 'Granted' : 'Not granted',
                  ),
                ),
                trailing: TextButton(
                  onPressed: () {
                    context.read<UsageProvider>().requestPermission();
                  },
                  child: const Text('Open Settings'),
                ),
              ),
              const Divider(),

              const _SectionHeader(title: 'About'),
              const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('App Manager'),
                subtitle: Text('Version 1.0.0\nBy Mithun Gowda B'),
              ),
            ],
          );
        },
      ),
    );
  }

  String _themeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System default';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
