import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ScannerOverlayWidget extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String) onBarcodeScanned;

  const ScannerOverlayWidget({
    Key? key,
    required this.onClose,
    required this.onBarcodeScanned,
  }) : super(key: key);

  @override
  State<ScannerOverlayWidget> createState() => _ScannerOverlayWidgetState();
}

class _ScannerOverlayWidgetState extends State<ScannerOverlayWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _flashlightOn = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat(reverse: true);

    // Simulate barcode detection after 5 seconds
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        widget.onBarcodeScanned("FL-2024-003");
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleFlashlight() {
    setState(() {
      _flashlightOn = !_flashlightOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.8),
      child: Stack(
        children: [
          // Camera Preview Placeholder
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
            child: Center(
              child: Container(
                width: 80.w,
                height: 60.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    // Scanning Animation
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Positioned(
                          top: _animation.value * (60.w - 4),
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  AppTheme.lightTheme.colorScheme.tertiary,
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // Corner Indicators
                    Positioned(
                      top: 2.w,
                      left: 2.w,
                      child: Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                              width: 3,
                            ),
                            left: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 2.w,
                      right: 2.w,
                      child: Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                              width: 3,
                            ),
                            right: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 2.w,
                      left: 2.w,
                      child: Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                              width: 3,
                            ),
                            left: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 2.w,
                      right: 2.w,
                      child: Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                              width: 3,
                            ),
                            right: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Top Controls
          Positioned(
            top: MediaQuery.of(context).padding.top + 2.h,
            left: 4.w,
            right: 4.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: widget.onClose,
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                IconButton(
                  onPressed: _toggleFlashlight,
                  icon: CustomIconWidget(
                    iconName: _flashlightOn ? 'flash_on' : 'flash_off',
                    color: _flashlightOn
                        ? AppTheme.lightTheme.colorScheme.tertiary
                        : Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),

          // Instructions
          Positioned(
            bottom: 15.h,
            left: 4.w,
            right: 4.w,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w,
                    vertical: 2.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Scanner le code-barres',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Positionnez le code-barres dans le cadre\npour le scanner automatiquement',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'qr_code',
                      color: Colors.white.withValues(alpha: 0.6),
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Code-barres détecté automatiquement',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
