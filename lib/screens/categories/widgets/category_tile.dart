import 'package:flutter/material.dart';
import 'package:app_management/models/category.dart';
import 'package:app_management/utils/formatters.dart';

class CategoryTile extends StatelessWidget {
  final Category category;
  final int totalMinutes;
  final int appCount;
  final VoidCallback onTap;

  const CategoryTile({
    super.key,
    required this.category,
    required this.totalMinutes,
    required this.appCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: category.color.withOpacity(0.15),
          child: Icon(category.icon, color: category.color),
        ),
        title: Text(category.name),
        subtitle: Text(
          totalMinutes > 0
              ? '${Formatters.formatMinutes(totalMinutes)} - $appCount app${appCount == 1 ? '' : 's'}'
              : 'No usage today',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
