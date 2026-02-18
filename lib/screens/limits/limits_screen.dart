import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_management/providers/category_provider.dart';
import 'package:app_management/providers/usage_provider.dart';
import 'package:app_management/screens/limits/widgets/limit_editor.dart';
import 'package:app_management/utils/formatters.dart';
import 'package:app_management/widgets/loading_indicator.dart';

class LimitsScreen extends StatelessWidget {
  const LimitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Limits'),
      ),
      body: Consumer2<CategoryProvider, UsageProvider>(
        builder: (context, categoryProvider, usageProvider, _) {
          if (categoryProvider.isLoading) {
            return const LoadingIndicator(message: 'Loading...');
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categoryProvider.categories.length,
            itemBuilder: (context, index) {
              final category = categoryProvider.categories[index];
              final summary = usageProvider.categorySummaries.cast<dynamic>().firstWhere(
                    (s) => s.categoryId == category.id,
                    orElse: () => null,
                  );
              final usedMinutes = summary?.totalMinutes ?? 0;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(category.icon, color: category.color),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              category.name,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          if (usedMinutes > 0)
                            Text(
                              'Used: ${Formatters.formatMinutesShort(usedMinutes)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LimitEditor(
                        currentLimit: category.dailyLimitMinutes,
                        color: category.color,
                        onChanged: (minutes) {
                          categoryProvider.updateLimit(category.id!, minutes);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
