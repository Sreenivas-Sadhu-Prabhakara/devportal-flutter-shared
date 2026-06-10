import 'package:flutter/material.dart';

import '../theme/tokens.dart';

enum BadgeTone { neutral, success, warn, danger, info, accent }

/// Small uppercase status pill.
class StatusBadge extends StatelessWidget {
  const StatusBadge(this.label, {super.key, this.tone = BadgeTone.neutral});

  final String label;
  final BadgeTone tone;

  Color get _color => switch (tone) {
        BadgeTone.success => AppColors.success,
        BadgeTone.warn => AppColors.warn,
        BadgeTone.danger => AppColors.danger,
        BadgeTone.info => AppColors.info,
        BadgeTone.accent => AppColors.accent,
        BadgeTone.neutral => AppColors.textLo,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _color.withValues(alpha: 0.45)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: _color,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
