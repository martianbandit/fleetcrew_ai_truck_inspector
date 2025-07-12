import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AlertCardWidget extends StatelessWidget {
  final Map<String, dynamic> alert;

  const AlertCardWidget({
    super.key,
    required this.alert,
  });

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return AppTheme.getStatusColor('failed');
      case 'warning':
        return AppTheme.getStatusColor('warning');
      case 'info':
        return AppTheme.lightTheme.colorScheme.primary;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getSeverityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return 'error';
      case 'warning':
        return 'warning';
      case 'info':
        return 'info';
      default:
        return 'help';
    }
  }

  String _getSeverityText(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return 'CRITIQUE';
      case 'warning':
        return 'ATTENTION';
      case 'info':
        return 'INFO';
      default:
        return severity.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final severityColor = _getSeverityColor(alert["severity"] as String);
    final severityIcon = _getSeverityIcon(alert["severity"] as String);
    final severityText = _getSeverityText(alert["severity"] as String);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: severityColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: severityColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: severityColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: severityIcon,
                      color: severityColor,
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      severityText,
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: severityColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                alert["timestamp"] as String,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            alert["title"] as String,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            alert["description"] as String,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (alert["vehicleId"] != null) ...[
            SizedBox(height: 1.5.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'local_shipping',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Véhicule: ${alert["vehicleId"]}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
