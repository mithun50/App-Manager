import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_management/providers/usage_provider.dart';
import 'package:app_management/screens/dashboard/widgets/usage_summary_card.dart';
import 'package:app_management/screens/dashboard/widgets/daily_chart.dart';
import 'package:app_management/screens/dashboard/widgets/permission_prompt.dart';
import 'package:app_management/utils/formatters.dart';
import 'package:app_management/widgets/loading_indicator.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<UsageProvider>().refreshUsageData();
            },
          ),
        ],
      ),
      body: Consumer<UsageProvider>(
        builder: (context, provider, _) {
          if (!provider.hasPermission) {
            return const PermissionPrompt();
          }

          if (provider.isLoading) {
            return const LoadingIndicator(message: 'Loading usage data...');
          }

          return RefreshIndicator(
            onRefresh: () => provider.refreshUsageData(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Total usage card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          'Today\'s Screen Time',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          Formatters.formatMinutes(provider.totalMinutesToday),
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Chart
                if (provider.categorySummaries.isNotEmpty) ...[
                  const DailyChart(),
                  const SizedBox(height: 16),
                ],

                // Category summaries
                Text(
                  'By Category',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...provider.categorySummaries
                    .where((s) => s.totalMinutes > 0)
                    .map((summary) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: UsageSummaryCard(summary: summary),
                        )),
              ],
            ),
          );
        },
      ),
    );
  }
}
