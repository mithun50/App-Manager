import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_management/providers/category_provider.dart';
import 'package:app_management/providers/usage_provider.dart';
import 'package:app_management/screens/categories/category_detail_screen.dart';
import 'package:app_management/screens/categories/widgets/category_tile.dart';
import 'package:app_management/widgets/empty_state.dart';
import 'package:app_management/widgets/loading_indicator.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: Consumer2<CategoryProvider, UsageProvider>(
        builder: (context, categoryProvider, usageProvider, _) {
          if (categoryProvider.isLoading) {
            return const LoadingIndicator(message: 'Loading categories...');
          }

          if (categoryProvider.categories.isEmpty) {
            return const EmptyState(
              icon: Icons.category_outlined,
              title: 'No Categories',
              message: 'Categories will appear here.',
            );
          }

          final summaries = usageProvider.categorySummaries;

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: categoryProvider.categories.length,
            itemBuilder: (context, index) {
              final category = categoryProvider.categories[index];
              final summary = summaries.cast<dynamic>().firstWhere(
                    (s) => s.categoryId == category.id,
                    orElse: () => null,
                  );

              return CategoryTile(
                category: category,
                totalMinutes: summary?.totalMinutes ?? 0,
                appCount: summary?.appCount ?? 0,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CategoryDetailScreen(category: category),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
