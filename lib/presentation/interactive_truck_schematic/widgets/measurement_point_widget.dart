import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MeasurementPointWidget extends StatefulWidget {
  final Map<String, dynamic> measurementPoint;
  final Color statusColor;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const MeasurementPointWidget({
    Key? key,
    required this.measurementPoint,
    required this.statusColor,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  State<MeasurementPointWidget> createState() => _MeasurementPointWidgetState();
}

class _MeasurementPointWidgetState extends State<MeasurementPointWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start pulsing animation for live data points
    if (widget.measurementPoint["isLive"] == true) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLive = widget.measurementPoint["isLive"] == true;
    final hasPhoto = widget.measurementPoint["hasPhoto"] == true;
    final status = widget.measurementPoint["status"] as String;

    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: isLive ? _pulseAnimation.value : 1.0,
            child: Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.statusColor,
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.statusColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: isLive ? 2 : 0,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Main status indicator
                  Center(
                    child: Container(
                      width: 4.w,
                      height: 4.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.lightTheme.colorScheme.surface,
                      ),
                      child: Center(
                        child: _getStatusIcon(status),
                      ),
                    ),
                  ),

                  // Live data indicator
                  if (isLive)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 2.w,
                        height: 2.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            width: 1,
                          ),
                        ),
                      ),
                    ),

                  // Photo indicator
                  if (hasPhoto)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        width: 2.w,
                        height: 2.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            width: 1,
                          ),
                        ),
                        child: CustomIconWidget(
                          iconName: 'camera_alt',
                          color: AppTheme.lightTheme.colorScheme.surface,
                          size: 8,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getStatusIcon(String status) {
    switch (status) {
      case 'passed':
        return CustomIconWidget(
          iconName: 'check',
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 12,
        );
      case 'warning':
        return CustomIconWidget(
          iconName: 'warning',
          color: const Color(0xFFB8860B),
          size: 12,
        );
      case 'failed':
        return CustomIconWidget(
          iconName: 'close',
          color: AppTheme.lightTheme.colorScheme.error,
          size: 12,
        );
      case 'not_measured':
      default:
        return CustomIconWidget(
          iconName: 'radio_button_unchecked',
          color: Colors.grey,
          size: 12,
        );
    }
  }
}
