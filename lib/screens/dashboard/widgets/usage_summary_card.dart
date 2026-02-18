import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_management/models/daily_summary.dart';
import 'package:app_management/providers/category_provider.dart';
import 'package:app_management/utils/formatters.dart';
import 'package:app_management/widgets/usage_progress_bar.dart';

class UsageSummaryCard extends StatelessWidget {
  final DailySummary summary;

  const UsageSummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final category = context.read<CategoryProvider>().getCategoryById(summary.categoryId);
    final color = category?.color ?? Theme.of(context).colorScheme.primary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(category?.icon ?? Icons.apps, color: color, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    summary.categoryName,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Text(
                  Formatters.formatMinutes(summary.totalMinutes),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (summary.hasLimit) ...[
              const SizedBox(height: 12),
              UsageProgressBar(
                value: summary.usagePercent,
                color: color,
              ),
              const SizedBox(height: 4),
              Text(
                summary.isOverLimit
                    ? 'Limit exceeded by ${Formatters.formatMinutes(summary.totalMinutes - summary.limitMinutes)}'
                    : '${Formatters.formatMinutes(summary.remainingMinutes)} remaining',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: summary.isOverLimit
                      ? Theme.of(context).colorScheme.error
                      : null,
                ),
              ),
            ],
            if (summary.appCount > 0) ...[
              const SizedBox(height: 4),
              Text(
                '${summary.appCount} app${summary.appCount == 1 ? '' : 's'}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
