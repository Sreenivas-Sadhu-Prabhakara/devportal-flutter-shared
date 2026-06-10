import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A lightweight area/line chart (no external chart dependency).
class MiniAreaChart extends StatelessWidget {
  const MiniAreaChart({
    super.key,
    required this.values,
    this.color = AppColors.accent,
    this.height = 160,
  });

  final List<double> values;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _AreaPainter(values, color)),
    );
  }
}

class _AreaPainter extends CustomPainter {
  _AreaPainter(this.values, this.color);

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final maxV = values.reduce(math.max);
    final minV = values.reduce(math.min);
    final range = (maxV - minV).abs() < 1e-9 ? 1.0 : (maxV - minV);
    const pad = 8.0;
    final w = size.width;
    final h = size.height - pad;

    double x(int i) =>
        values.length == 1 ? w / 2 : i / (values.length - 1) * w;
    double y(double v) => pad + h - ((v - minV) / range) * h;

    // grid lines
    final grid = Paint()
      ..color = AppColors.line.withValues(alpha: 0.6)
      ..strokeWidth = 1;
    for (var i = 0; i <= 3; i++) {
      final gy = pad + h * i / 3;
      canvas.drawLine(Offset(0, gy), Offset(w, gy), grid);
    }

    final line = Path();
    for (var i = 0; i < values.length; i++) {
      final p = Offset(x(i), y(values[i]));
      if (i == 0) {
        line.moveTo(p.dx, p.dy);
      } else {
        line.lineTo(p.dx, p.dy);
      }
    }

    final fill = Path.from(line)
      ..lineTo(x(values.length - 1), pad + h)
      ..lineTo(x(0), pad + h)
      ..close();

    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.35), color.withValues(alpha: 0)],
        ).createShader(Rect.fromLTWH(0, 0, w, size.height)),
    );

    canvas.drawPath(
      line,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _AreaPainter old) =>
      old.values != values || old.color != color;
}

/// A horizontal labelled bar (used for status-code / breakdown views).
class StatBar extends StatelessWidget {
  const StatBar({
    super.key,
    required this.label,
    required this.fraction,
    required this.trailing,
    this.color = AppColors.accent,
  });

  final String label;
  final double fraction; // 0..1
  final String trailing;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textLo,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: fraction.clamp(0, 1),
                minHeight: 8,
                backgroundColor: AppColors.surfaceRaised,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 64,
            child: Text(
              trailing,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.textMid,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
