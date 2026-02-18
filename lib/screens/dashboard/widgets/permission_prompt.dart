import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_management/providers/usage_provider.dart';

class PermissionPrompt extends StatelessWidget {
  const PermissionPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Usage Access Required',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'App Manager needs permission to view app usage data. '
              'This allows tracking screen time and enforcing limits.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () async {
                final provider = context.read<UsageProvider>();
                await provider.requestPermission();
              },
              icon: const Icon(Icons.settings),
              label: const Text('Grant Permission'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                context.read<UsageProvider>().checkPermission();
              },
              child: const Text('I\'ve already granted it'),
            ),
          ],
        ),
      ),
    );
  }
}
