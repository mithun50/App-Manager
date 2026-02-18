import 'package:flutter/material.dart';

class UsageProgressBar extends StatelessWidget {
  final double value;
  final Color color;
  final double height;

  const UsageProgressBar({
    super.key,
    required this.value,
    required this.color,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    final clampedValue = value.clamp(0.0, 1.0);
    final barColor = value >= 1.0
        ? Theme.of(context).colorScheme.error
        : value >= 0.8
            ? Colors.orange
            : color;

    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: LinearProgressIndicator(
        value: clampedValue,
        minHeight: height,
        backgroundColor: barColor.withOpacity(0.15),
        valueColor: AlwaysStoppedAnimation<Color>(barColor),
      ),
    );
  }
}
