import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FloatingToolbarWidget extends StatelessWidget {
  final double completionPercentage;
  final bool isMetricUnits;
  final VoidCallback onToggleUnits;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onResetZoom;

  const FloatingToolbarWidget({
    Key? key,
    required this.completionPercentage,
    required this.isMetricUnits,
    required this.onToggleUnits,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onResetZoom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Progress Indicator
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progression',
                  style: AppTheme.lightTheme.textTheme.labelSmall,
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: completionPercentage,
                        backgroundColor: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '${(completionPercentage * 100).toInt()}%',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(width: 4.w),

          // Units Toggle
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: GestureDetector(
              onTap: onToggleUnits,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'straighten',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    isMetricUnits ? 'Métrique' : 'Impérial',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: 2.w),

          // Zoom Controls
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildZoomButton(
                icon: 'zoom_out',
                onPressed: onZoomOut,
              ),
              SizedBox(width: 1.w),
              _buildZoomButton(
                icon: 'center_focus_strong',
                onPressed: onResetZoom,
              ),
              SizedBox(width: 1.w),
              _buildZoomButton(
                icon: 'zoom_in',
                onPressed: onZoomIn,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildZoomButton({
    required String icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 8.w,
        height: 8.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: icon,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 18,
          ),
        ),
      ),
    );
  }
}
