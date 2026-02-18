class AppUsage {
  final int? id;
  final String packageName;
  final String appName;
  final int categoryId;
  final int usageMinutes;
  final String date;

  const AppUsage({
    this.id,
    required this.packageName,
    required this.appName,
    required this.categoryId,
    required this.usageMinutes,
    required this.date,
  });

  factory AppUsage.fromMap(Map<String, dynamic> map) {
    return AppUsage(
      id: map['id'] as int?,
      packageName: map['packageName'] ?? map['package_name'] as String,
      appName: map['appName'] ?? map['app_name'] as String,
      categoryId: map['categoryId'] ?? map['category_id'] as int,
      usageMinutes: map['usageMinutes'] ?? map['usage_minutes'] as int,
      date: map['date'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'package_name': packageName,
      'app_name': appName,
      'category_id': categoryId,
      'usage_minutes': usageMinutes,
      'date': date,
    };
  }

  AppUsage copyWith({
    int? id,
    String? packageName,
    String? appName,
    int? categoryId,
    int? usageMinutes,
    String? date,
  }) {
    return AppUsage(
      id: id ?? this.id,
      packageName: packageName ?? this.packageName,
      appName: appName ?? this.appName,
      categoryId: categoryId ?? this.categoryId,
      usageMinutes: usageMinutes ?? this.usageMinutes,
      date: date ?? this.date,
    );
  }
}
