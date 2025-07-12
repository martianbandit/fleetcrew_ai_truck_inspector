import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MeasurementBottomSheet extends StatefulWidget {
  final Map<String, dynamic> measurementPoint;
  final bool isMetricUnits;
  final Function(Map<String, dynamic>) onMeasurementUpdated;

  const MeasurementBottomSheet({
    Key? key,
    required this.measurementPoint,
    required this.isMetricUnits,
    required this.onMeasurementUpdated,
  }) : super(key: key);

  @override
  State<MeasurementBottomSheet> createState() => _MeasurementBottomSheetState();
}

class _MeasurementBottomSheetState extends State<MeasurementBottomSheet> {
  late TextEditingController _valueController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final currentValue = widget.measurementPoint["currentValue"];
    _valueController = TextEditingController(
      text: currentValue != null ? currentValue.toString() : '',
    );
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'passed':
        return 'Conforme';
      case 'warning':
        return 'Attention';
      case 'failed':
        return 'Défaillant';
      case 'not_measured':
      default:
        return 'Non mesuré';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'passed':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'warning':
        return const Color(0xFFB8860B);
      case 'failed':
        return AppTheme.lightTheme.colorScheme.error;
      case 'not_measured':
      default:
        return Colors.grey;
    }
  }

  void _saveValue() {
    final newValue = double.tryParse(_valueController.text);
    if (newValue != null) {
      final updatedPoint = Map<String, dynamic>.from(widget.measurementPoint);
      updatedPoint["currentValue"] = newValue;
      updatedPoint["lastMeasured"] = DateTime.now().toString();

      // Determine status based on value range
      final minValue = updatedPoint["minValue"] as double;
      final maxValue = updatedPoint["maxValue"] as double;

      if (newValue >= minValue && newValue <= maxValue) {
        updatedPoint["status"] = "passed";
      } else if (newValue >= minValue * 0.9 && newValue <= maxValue * 1.1) {
        updatedPoint["status"] = "warning";
      } else {
        updatedPoint["status"] = "failed";
      }

      widget.onMeasurementUpdated(updatedPoint);
      setState(() {
        _isEditing = false;
      });
    }
  }

  void _capturePhoto() {
    // Mock photo capture
    final updatedPoint = Map<String, dynamic>.from(widget.measurementPoint);
    updatedPoint["hasPhoto"] = true;
    widget.onMeasurementUpdated(updatedPoint);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Photo capturée pour ${widget.measurementPoint["name"]}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.measurementPoint["status"] as String;
    final currentValue = widget.measurementPoint["currentValue"];
    final minValue = widget.measurementPoint["minValue"] as double;
    final maxValue = widget.measurementPoint["maxValue"] as double;
    final unit = widget.measurementPoint["unit"] as String;
    final lastMeasured = widget.measurementPoint["lastMeasured"] as String?;
    final hasPhoto = widget.measurementPoint["hasPhoto"] == true;
    final isLive = widget.measurementPoint["isLive"] == true;

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getStatusColor(status),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: status == 'passed'
                          ? 'check'
                          : status == 'warning'
                              ? 'warning'
                              : status == 'failed'
                                  ? 'close'
                                  : 'radio_button_unchecked',
                      color: AppTheme.lightTheme.colorScheme.surface,
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.measurementPoint["name"] as String,
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      Text(
                        _getStatusText(status),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: _getStatusColor(status),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isLive)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 2.w,
                          height: 2.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'En direct',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current Value Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Valeur Actuelle',
                          style: AppTheme.lightTheme.textTheme.titleSmall,
                        ),
                        SizedBox(height: 2.h),
                        _isEditing
                            ? Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _valueController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: 'Entrer la valeur',
                                        suffixText: unit,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  IconButton(
                                    onPressed: _saveValue,
                                    icon: CustomIconWidget(
                                      iconName: 'check',
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      size: 24,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isEditing = false;
                                      });
                                    },
                                    icon: CustomIconWidget(
                                      iconName: 'close',
                                      color:
                                          AppTheme.lightTheme.colorScheme.error,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Text(
                                    currentValue != null
                                        ? '$currentValue $unit'
                                        : 'Non mesuré',
                                    style: AppTheme
                                        .lightTheme.textTheme.headlineSmall
                                        ?.copyWith(
                                      color: _getStatusColor(status),
                                    ),
                                  ),
                                  const Spacer(),
                                  if (!isLive)
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isEditing = true;
                                        });
                                      },
                                      icon: CustomIconWidget(
                                        iconName: 'edit',
                                        color: AppTheme
                                            .lightTheme.colorScheme.primary,
                                        size: 24,
                                      ),
                                    ),
                                ],
                              ),
                      ],
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Acceptable Range
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Plage Acceptable',
                          style: AppTheme.lightTheme.textTheme.titleSmall,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          '$minValue - $maxValue $unit',
                          style: AppTheme.lightTheme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Last Measured
                  if (lastMeasured != null)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dernière Mesure',
                            style: AppTheme.lightTheme.textTheme.titleSmall,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            DateTime.parse(lastMeasured)
                                .toString()
                                .substring(0, 16),
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: 2.h),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _capturePhoto,
                          icon: CustomIconWidget(
                            iconName: hasPhoto ? 'photo_camera' : 'camera_alt',
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            size: 20,
                          ),
                          label:
                              Text(hasPhoto ? 'Photo Prise' : 'Prendre Photo'),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/measurement-detail',
                                arguments: widget.measurementPoint);
                          },
                          icon: CustomIconWidget(
                            iconName: 'history',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          ),
                          label: const Text('Historique'),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
