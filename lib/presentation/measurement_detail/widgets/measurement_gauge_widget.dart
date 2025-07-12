import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MeasurementGaugeWidget extends StatelessWidget {
  final double currentValue;
  final double minValue;
  final double maxValue;
  final String unit;
  final bool isWithinSpec;

  const MeasurementGaugeWidget({
    Key? key,
    required this.currentValue,
    required this.minValue,
    required this.maxValue,
    required this.unit,
    required this.isWithinSpec,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Indicateur visuel',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 3.h),
          Center(
            child: SizedBox(
              width: 60.w,
              height: 30.h,
              child: CustomPaint(
                painter: GaugePainter(
                  currentValue: currentValue,
                  minValue: minValue,
                  maxValue: maxValue,
                  isWithinSpec: isWithinSpec,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 8.h),
                      Text(
                        currentValue.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          color: isWithinSpec
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.error,
                        ),
                      ),
                      Text(
                        unit,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRangeIndicator(
                  'Min', minValue, AppTheme.lightTheme.colorScheme.error),
              _buildRangeIndicator('Optimal', (minValue + maxValue) / 2,
                  AppTheme.lightTheme.colorScheme.primary),
              _buildRangeIndicator(
                  'Max', maxValue, AppTheme.lightTheme.colorScheme.error),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRangeIndicator(String label, double value, Color color) {
    return Column(
      children: [
        Container(
          width: 3.w,
          height: 3.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 11.sp,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class GaugePainter extends CustomPainter {
  final double currentValue;
  final double minValue;
  final double maxValue;
  final bool isWithinSpec;

  GaugePainter({
    required this.currentValue,
    required this.minValue,
    required this.maxValue,
    required this.isWithinSpec,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 20;

    // Background arc
    final backgroundPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi,
      math.pi,
      false,
      backgroundPaint,
    );

    // Acceptable range arc
    final acceptableRangePaint = Paint()
      ..color = AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi,
      math.pi,
      false,
      acceptableRangePaint,
    );

    // Current value indicator
    final valueRatio = (currentValue - minValue) / (maxValue - minValue);
    final valueAngle = -math.pi + (math.pi * valueRatio.clamp(0.0, 1.0));

    final valuePaint = Paint()
      ..color = isWithinSpec
          ? AppTheme.lightTheme.colorScheme.primary
          : AppTheme.lightTheme.colorScheme.error
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi,
      valueAngle + math.pi,
      false,
      valuePaint,
    );

    // Needle
    final needleEnd = Offset(
      center.dx + radius * 0.8 * math.cos(valueAngle),
      center.dy + radius * 0.8 * math.sin(valueAngle),
    );

    final needlePaint = Paint()
      ..color = isWithinSpec
          ? AppTheme.lightTheme.colorScheme.primary
          : AppTheme.lightTheme.colorScheme.error
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, needleEnd, needlePaint);

    // Center dot
    final centerDotPaint = Paint()
      ..color = isWithinSpec
          ? AppTheme.lightTheme.colorScheme.primary
          : AppTheme.lightTheme.colorScheme.error;

    canvas.drawCircle(center, 6, centerDotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
