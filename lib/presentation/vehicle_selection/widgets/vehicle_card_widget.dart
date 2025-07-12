import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VehicleCardWidget extends StatelessWidget {
  final Map<String, dynamic> vehicle;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const VehicleCardWidget({
    Key? key,
    required this.vehicle,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  Color _getStatusColor() {
    final status = vehicle["status"] as String;
    switch (status) {
      case 'compliant':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'due_soon':
        return Color(0xFFFFB74D); // Warning amber
      case 'overdue':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getStatusText() {
    final status = vehicle["status"] as String;
    switch (status) {
      case 'compliant':
        return 'Conforme';
      case 'due_soon':
        return 'Échéance proche';
      case 'overdue':
        return 'En retard';
      default:
        return 'Inconnu';
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  int _getDaysUntilDue() {
    final nextInspection = vehicle["nextInspectionDue"] as DateTime;
    return nextInspection.difference(DateTime.now()).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final daysUntilDue = _getDaysUntilDue();

    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      child: Material(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        shadowColor: AppTheme.lightTheme.colorScheme.shadow,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Vehicle Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomImageWidget(
                        imageUrl: vehicle["imageUrl"] as String,
                        width: 20.w,
                        height: 15.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 4.w),

                    // Vehicle Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  vehicle["unitNumber"] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                  vertical: 0.5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _getStatusText(),
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: statusColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            "${vehicle["make"]} ${vehicle["model"]} (${vehicle["year"]})",
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'location_on',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 16,
                              ),
                              SizedBox(width: 1.w),
                              Expanded(
                                child: Text(
                                  vehicle["location"] as String,
                                  style:
                                      AppTheme.lightTheme.textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Inspection Info
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface
                        .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dernière inspection',
                                  style:
                                      AppTheme.lightTheme.textTheme.labelMedium,
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  _formatDate(
                                      vehicle["lastInspection"] as DateTime),
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 4.h,
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Prochaine échéance',
                                  style:
                                      AppTheme.lightTheme.textTheme.labelMedium,
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  daysUntilDue > 0
                                      ? 'Dans $daysUntilDue jours'
                                      : daysUntilDue == 0
                                          ? 'Aujourd\'hui'
                                          : 'En retard de ${-daysUntilDue} jours',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: daysUntilDue < 0
                                        ? AppTheme.lightTheme.colorScheme.error
                                        : daysUntilDue <= 7
                                            ? Color(0xFFFFB74D)
                                            : AppTheme.lightTheme.colorScheme
                                                .onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kilométrage',
                                  style:
                                      AppTheme.lightTheme.textTheme.labelMedium,
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  '${(vehicle["mileage"] as int).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ')} km',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 4.h,
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Conducteur',
                                  style:
                                      AppTheme.lightTheme.textTheme.labelMedium,
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  vehicle["driver"] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 2.h),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => onLongPress(),
                        icon: CustomIconWidget(
                          iconName: 'more_horiz',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 18,
                        ),
                        label: Text('Actions'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: onTap,
                        icon: CustomIconWidget(
                          iconName: 'assignment',
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          size: 18,
                        ),
                        label: Text('Inspecter'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
