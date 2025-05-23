import 'package:flutter/material.dart';
import 'dart:math';

class ExerciseGauge extends StatelessWidget {
  final double progress; // From 0.0 to 1.0
  final Color backgroundColor;
  final Color progressColor;

  const ExerciseGauge({
    super.key,
    required this.progress,
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SemiCirclePainter(
        progress: progress.clamp(0.0, 1.0),
        backgroundColor: backgroundColor,
        progressColor: progressColor,
      ),
      size: const Size(200, 100), // Width and height for semi-circle
    );
  }
}

class _SemiCirclePainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;

  _SemiCirclePainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40
    ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 41
      ..strokeCap = StrokeCap.round;

    // Draw background arc (semi-circle)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi, // Start from left
      pi, // Sweep half circle
      false,
      backgroundPaint,
    );

    // Draw progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi * progress, // Sweep based on progress
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
