import 'package:flutter/material.dart';
import 'package:app_management/utils/formatters.dart';

class LimitEditor extends StatefulWidget {
  final int currentLimit;
  final Color color;
  final ValueChanged<int> onChanged;

  const LimitEditor({
    super.key,
    required this.currentLimit,
    required this.color,
    required this.onChanged,
  });

  @override
  State<LimitEditor> createState() => _LimitEditorState();
}

class _LimitEditorState extends State<LimitEditor> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.currentLimit.toDouble();
  }

  @override
  void didUpdateWidget(LimitEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentLimit != widget.currentLimit) {
      _value = widget.currentLimit.toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _value == 0 ? 'No limit' : Formatters.formatMinutes(_value.round()),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: _value == 0 ? Theme.of(context).textTheme.bodySmall?.color : widget.color,
              ),
            ),
            if (_value > 0)
              TextButton(
                onPressed: () {
                  setState(() => _value = 0);
                  widget.onChanged(0);
                },
                child: const Text('Remove'),
              ),
          ],
        ),
        Slider(
          value: _value,
          min: 0,
          max: 480, // 8 hours
          divisions: 32, // 15-min increments
          activeColor: widget.color,
          label: _value == 0 ? 'No limit' : Formatters.formatMinutesShort(_value.round()),
          onChanged: (v) {
            setState(() => _value = v);
          },
          onChangeEnd: (v) {
            widget.onChanged(v.round());
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Off', style: Theme.of(context).textTheme.bodySmall),
            Text('8h', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}
