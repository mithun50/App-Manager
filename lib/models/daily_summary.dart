class DailySummary {
  final int categoryId;
  final String categoryName;
  final int totalMinutes;
  final int limitMinutes;
  final int appCount;

  const DailySummary({
    required this.categoryId,
    required this.categoryName,
    required this.totalMinutes,
    required this.limitMinutes,
    required this.appCount,
  });

  double get usagePercent {
    if (limitMinutes <= 0) return 0.0;
    return (totalMinutes / limitMinutes).clamp(0.0, 2.0);
  }

  bool get isOverLimit => limitMinutes > 0 && totalMinutes >= limitMinutes;
  bool get isNearLimit => limitMinutes > 0 && totalMinutes >= (limitMinutes * 0.8);
  bool get hasLimit => limitMinutes > 0;

  int get remainingMinutes {
    if (limitMinutes <= 0) return -1;
    return (limitMinutes - totalMinutes).clamp(0, limitMinutes);
  }
}
