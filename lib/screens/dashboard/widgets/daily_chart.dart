import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:app_management/providers/usage_provider.dart';
import 'package:app_management/providers/category_provider.dart';
import 'package:app_management/utils/formatters.dart';

class DailyChart extends StatelessWidget {
  const DailyChart({super.key});

  @override
  Widget build(BuildContext context) {
    final summaries = context.watch<UsageProvider>().categorySummaries;
    final categoryProvider = context.read<CategoryProvider>();

    final activeSummaries = summaries.where((s) => s.totalMinutes > 0).toList();

    if (activeSummaries.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Usage Breakdown',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: activeSummaries.map((summary) {
                    final category = categoryProvider.getCategoryById(summary.categoryId);
                    final color = category?.color ?? Colors.grey;

                    return PieChartSectionData(
                      value: summary.totalMinutes.toDouble(),
                      title: Formatters.formatMinutesShort(summary.totalMinutes),
                      color: color,
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: activeSummaries.map((summary) {
                final category = categoryProvider.getCategoryById(summary.categoryId);
                final color = category?.color ?? Colors.grey;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      summary.categoryName,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
