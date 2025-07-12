import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TruckSchematicPainter extends CustomPainter {
  final String selectedCategory;

  TruckSchematicPainter({
    required this.selectedCategory,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = AppTheme.lightTheme.colorScheme.outline;

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.8);

    // Draw truck outline
    _drawTruckOutline(canvas, size, paint, fillPaint);

    // Highlight category-specific areas
    _highlightCategoryAreas(canvas, size);
  }

  void _drawTruckOutline(
      Canvas canvas, Size size, Paint paint, Paint fillPaint) {
    final width = size.width;
    final height = size.height;

    // Main truck body
    final truckBody = RRect.fromRectAndRadius(
      Rect.fromLTWH(width * 0.1, height * 0.2, width * 0.8, height * 0.6),
      const Radius.circular(8),
    );
    canvas.drawRRect(truckBody, fillPaint);
    canvas.drawRRect(truckBody, paint);

    // Cab
    final cab = RRect.fromRectAndRadius(
      Rect.fromLTWH(width * 0.1, height * 0.8, width * 0.8, height * 0.15),
      const Radius.circular(6),
    );
    canvas.drawRRect(cab, fillPaint);
    canvas.drawRRect(cab, paint);

    // Front bumper
    final bumper =
        Rect.fromLTWH(width * 0.05, height * 0.85, width * 0.9, height * 0.05);
    canvas.drawRect(bumper, fillPaint);
    canvas.drawRect(bumper, paint);

    // Wheels
    _drawWheel(canvas, width * 0.25, height * 0.15, 20, paint,
        fillPaint); // Front left
    _drawWheel(canvas, width * 0.75, height * 0.15, 20, paint,
        fillPaint); // Front right
    _drawWheel(
        canvas, width * 0.25, height * 0.85, 20, paint, fillPaint); // Rear left
    _drawWheel(canvas, width * 0.75, height * 0.85, 20, paint,
        fillPaint); // Rear right

    // Engine compartment
    final engine = RRect.fromRectAndRadius(
      Rect.fromLTWH(width * 0.4, height * 0.75, width * 0.2, height * 0.1),
      const Radius.circular(4),
    );
    canvas.drawRRect(engine, paint);

    // Brake components (simplified)
    _drawBrakeComponent(canvas, width * 0.2, height * 0.72, paint);
    _drawBrakeComponent(canvas, width * 0.8, height * 0.72, paint);
    _drawBrakeComponent(canvas, width * 0.2, height * 0.28, paint);
    _drawBrakeComponent(canvas, width * 0.8, height * 0.28, paint);

    // Headlights
    _drawLight(canvas, width * 0.15, height * 0.9, paint, fillPaint);
    _drawLight(canvas, width * 0.85, height * 0.9, paint, fillPaint);

    // Fluid reservoirs
    _drawFluidReservoir(canvas, width * 0.55, height * 0.82, paint, fillPaint);
    _drawFluidReservoir(canvas, width * 0.45, height * 0.78, paint, fillPaint);
  }

  void _drawWheel(Canvas canvas, double x, double y, double radius, Paint paint,
      Paint fillPaint) {
    canvas.drawCircle(Offset(x, y), radius, fillPaint);
    canvas.drawCircle(Offset(x, y), radius, paint);

    // Rim details
    canvas.drawCircle(Offset(x, y), radius * 0.6, paint);
    for (int i = 0; i < 5; i++) {
      final angle = (i * 72) * (3.14159 / 180);
      final startX = x + (radius * 0.3) * math.cos(angle);
      final startY = y + (radius * 0.3) * math.sin(angle);
      final endX = x + (radius * 0.8) * math.cos(angle);
      final endY = y + (radius * 0.8) * math.sin(angle);
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }
  }

  void _drawBrakeComponent(Canvas canvas, double x, double y, Paint paint) {
    final brakeRect =
        Rect.fromCenter(center: Offset(x, y), width: 12, height: 8);
    canvas.drawRect(brakeRect, paint);
  }

  void _drawLight(
      Canvas canvas, double x, double y, Paint paint, Paint fillPaint) {
    canvas.drawCircle(Offset(x, y), 8, fillPaint);
    canvas.drawCircle(Offset(x, y), 8, paint);
  }

  void _drawFluidReservoir(
      Canvas canvas, double x, double y, Paint paint, Paint fillPaint) {
    final reservoir = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(x, y), width: 16, height: 12),
      const Radius.circular(2),
    );
    canvas.drawRRect(reservoir, fillPaint);
    canvas.drawRRect(reservoir, paint);
  }

  void _highlightCategoryAreas(Canvas canvas, Size size) {
    final highlightPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = _getCategoryColor().withValues(alpha: 0.1);

    switch (selectedCategory) {
      case 'Tires':
        // Highlight wheel areas
        canvas.drawCircle(
            Offset(size.width * 0.25, size.height * 0.15), 25, highlightPaint);
        canvas.drawCircle(
            Offset(size.width * 0.75, size.height * 0.15), 25, highlightPaint);
        canvas.drawCircle(
            Offset(size.width * 0.25, size.height * 0.85), 25, highlightPaint);
        canvas.drawCircle(
            Offset(size.width * 0.75, size.height * 0.85), 25, highlightPaint);
        break;
      case 'Engine':
        // Highlight engine area
        final engineArea = RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width * 0.35, size.height * 0.7, size.width * 0.3,
              size.height * 0.2),
          const Radius.circular(8),
        );
        canvas.drawRRect(engineArea, highlightPaint);
        break;
      case 'Brakes':
        // Highlight brake areas
        canvas.drawCircle(
            Offset(size.width * 0.2, size.height * 0.72), 15, highlightPaint);
        canvas.drawCircle(
            Offset(size.width * 0.8, size.height * 0.72), 15, highlightPaint);
        canvas.drawCircle(
            Offset(size.width * 0.2, size.height * 0.28), 15, highlightPaint);
        canvas.drawCircle(
            Offset(size.width * 0.8, size.height * 0.28), 15, highlightPaint);
        break;
      case 'Lights':
        // Highlight light areas
        canvas.drawCircle(
            Offset(size.width * 0.15, size.height * 0.9), 12, highlightPaint);
        canvas.drawCircle(
            Offset(size.width * 0.85, size.height * 0.9), 12, highlightPaint);
        break;
      case 'Fluids':
        // Highlight fluid reservoir areas
        canvas.drawCircle(
            Offset(size.width * 0.55, size.height * 0.82), 20, highlightPaint);
        canvas.drawCircle(
            Offset(size.width * 0.45, size.height * 0.78), 20, highlightPaint);
        break;
    }
  }

  Color _getCategoryColor() {
    switch (selectedCategory) {
      case 'Tires':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'Engine':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'Brakes':
        return AppTheme.lightTheme.colorScheme.error;
      case 'Lights':
        return const Color(0xFFFFB74D);
      case 'Fluids':
        return AppTheme.lightTheme.colorScheme.secondary;
      default:
        return AppTheme.lightTheme.colorScheme.outline;
    }
  }

  double cos(double angle) => math.cos(angle);
  double sin(double angle) => math.sin(angle);

  @override
  bool shouldRepaint(TruckSchematicPainter oldDelegate) {
    return oldDelegate.selectedCategory != selectedCategory;
  }
}