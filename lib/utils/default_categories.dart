import 'package:flutter/material.dart';
import 'package:app_management/models/category.dart';

class DefaultCategories {
  DefaultCategories._();

  static const List<Category> all = [
    Category(
      name: 'Social Media',
      icon: Icons.people,
      color: Color(0xFFE91E63),
    ),
    Category(
      name: 'Games',
      icon: Icons.sports_esports,
      color: Color(0xFF9C27B0),
    ),
    Category(
      name: 'Productivity',
      icon: Icons.work,
      color: Color(0xFF2196F3),
    ),
    Category(
      name: 'Entertainment',
      icon: Icons.movie,
      color: Color(0xFFFF9800),
    ),
    Category(
      name: 'Communication',
      icon: Icons.chat,
      color: Color(0xFF4CAF50),
    ),
    Category(
      name: 'News & Reading',
      icon: Icons.article,
      color: Color(0xFF795548),
    ),
    Category(
      name: 'Education',
      icon: Icons.school,
      color: Color(0xFF00BCD4),
    ),
    Category(
      name: 'Other',
      icon: Icons.apps,
      color: Color(0xFF607D8B),
    ),
  ];
}
