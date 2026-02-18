import 'package:flutter/material.dart';
import 'package:app_management/models/app_usage.dart';
import 'package:app_management/utils/formatters.dart';
import 'package:app_management/widgets/usage_progress_bar.dart';

class AppUsageTile extends StatelessWidget {
  final AppUsage appUsage;
  final int totalMinutes;
  final Color color;

  const AppUsageTile({
    super.key,
    required this.appUsage,
    required this.totalMinutes,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = totalMinutes > 0 ? appUsage.usageMinutes / totalMinutes : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    appUsage.appName,
                    style: Theme.of(context).textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  Formatters.formatMinutes(appUsage.usageMinutes),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            UsageProgressBar(
              value: fraction,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
