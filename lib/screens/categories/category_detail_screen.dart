import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_management/models/category.dart';
import 'package:app_management/models/app_usage.dart';
import 'package:app_management/providers/usage_provider.dart';
import 'package:app_management/screens/categories/widgets/app_usage_tile.dart';
import 'package:app_management/utils/formatters.dart';
import 'package:app_management/widgets/empty_state.dart';

class CategoryDetailScreen extends StatelessWidget {
  final Category category;

  const CategoryDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: FutureBuilder<List<AppUsage>>(
        future: context.read<UsageProvider>().getUsageForCategory(category.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final apps = snapshot.data ?? [];

          if (apps.isEmpty) {
            return const EmptyState(
              icon: Icons.apps_outlined,
              title: 'No Usage',
              message: 'No app usage recorded in this category today.',
            );
          }

          final totalMinutes = apps.fold<int>(0, (sum, a) => sum + a.usageMinutes);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(category.icon, color: category.color, size: 40),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Formatters.formatMinutes(totalMinutes),
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (category.dailyLimitMinutes > 0)
                              Text(
                                'Limit: ${Formatters.formatMinutes(category.dailyLimitMinutes)}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                          ],
                        ),
                      ),
                      Text(
                        '${apps.length} app${apps.length == 1 ? '' : 's'}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Apps',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ...apps.map((app) => AppUsageTile(
                    appUsage: app,
                    totalMinutes: totalMinutes,
                    color: category.color,
                  )),
            ],
          );
        },
      ),
    );
  }
}
