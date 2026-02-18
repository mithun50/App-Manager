import 'package:flutter/material.dart';

class Category {
  final int? id;
  final String name;
  final IconData icon;
  final Color color;
  final int dailyLimitMinutes;

  const Category({
    this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.dailyLimitMinutes = 0,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int?,
      name: map['name'] as String,
      icon: IconData(map['icon'] as int, fontFamily: 'MaterialIcons'),
      color: Color(map['color'] as int),
      dailyLimitMinutes: map['daily_limit_minutes'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': icon.codePoint,
      'color': color.value,
      'daily_limit_minutes': dailyLimitMinutes,
    };
  }

  Category copyWith({
    int? id,
    String? name,
    IconData? icon,
    Color? color,
    int? dailyLimitMinutes,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      dailyLimitMinutes: dailyLimitMinutes ?? this.dailyLimitMinutes,
    );
  }
}
