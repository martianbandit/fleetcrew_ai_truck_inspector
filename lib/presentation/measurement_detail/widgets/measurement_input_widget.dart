import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MeasurementInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String unit;
  final bool isWithinSpec;
  final VoidCallback onChanged;

  const MeasurementInputWidget({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.unit,
    required this.isWithinSpec,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isWithinSpec
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3)
              : AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Valeur mesurée',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: isWithinSpec
                      ? AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.error
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: isWithinSpec ? 'check_circle' : 'warning',
                      color: isWithinSpec
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.error,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      isWithinSpec ? 'Conforme' : 'Hors spec',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: isWithinSpec
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w700,
                    color: isWithinSpec
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.error,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: '0.0',
                    hintStyle: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.5),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) => onChanged(),
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Simulate Bluetooth reading
                    controller.text =
                        (8.1 + (0.4 * (DateTime.now().millisecond / 1000)))
                            .toStringAsFixed(1);
                    onChanged();
                    HapticFeedback.lightImpact();
                  },
                  icon: CustomIconWidget(
                    iconName: 'bluetooth',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 16,
                  ),
                  label: Text('Lecture auto'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                    foregroundColor:
                        AppTheme.lightTheme.colorScheme.onSecondary,
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              ElevatedButton(
                onPressed: () {
                  controller.clear();
                  onChanged();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                  foregroundColor: AppTheme.lightTheme.colorScheme.onSurface,
                  side: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline,
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                ),
                child: CustomIconWidget(
                  iconName: 'clear',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
