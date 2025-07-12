import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InspectionCardWidget extends StatelessWidget {
  final Map<String, dynamic> inspection;
  final VoidCallback onTap;
  final VoidCallback onViewReport;
  final VoidCallback onViewPhotos;
  final VoidCallback onShare;
  final VoidCallback onScheduleFollowUp;

  const InspectionCardWidget({
    Key? key,
    required this.inspection,
    required this.onTap,
    required this.onViewReport,
    required this.onViewPhotos,
    required this.onShare,
    required this.onScheduleFollowUp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = inspection["status"] as String;
    final statusColor = AppTheme.getStatusColor(status);
    final inspectionDate = inspection["inspectionDate"] as DateTime;
    final complianceScore = inspection["complianceScore"] as double;
    final issuesFound = inspection["issuesFound"] as int;

    return Dismissible(
      key: Key(inspection["id"]),
      direction: DismissDirection.startToEnd,
      background: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'visibility',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              'Actions',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        _showQuickActions(context);
        return false;
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    // Vehicle Thumbnail
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomImageWidget(
                        imageUrl: inspection["vehicleThumbnail"],
                        width: 15.w,
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
                              Text(
                                'Unité ${inspection["unitNumber"]}',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              _buildStatusBadge(status, statusColor),
                            ],
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            inspection["inspectionType"],
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'schedule',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 14,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                '${inspectionDate.day}/${inspectionDate.month}/${inspectionDate.year} ${inspectionDate.hour}:${inspectionDate.minute.toString().padLeft(2, '0')}',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 3.w),

                // Inspector Info
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'person',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      inspection["inspectorName"],
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    CustomIconWidget(
                      iconName: 'location_on',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      inspection["location"],
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 3.w),

                // Metrics Row
                Row(
                  children: [
                    _buildMetricChip(
                      icon: 'assessment',
                      label: '${complianceScore.toStringAsFixed(1)}%',
                      color: _getScoreColor(complianceScore),
                    ),
                    SizedBox(width: 2.w),
                    _buildMetricChip(
                      icon: 'timer',
                      label: inspection["duration"],
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: 2.w),
                    _buildMetricChip(
                      icon: issuesFound > 0 ? 'warning' : 'check_circle',
                      label: issuesFound > 0
                          ? '$issuesFound problème${issuesFound > 1 ? 's' : ''}'
                          : 'Aucun problème',
                      color: issuesFound > 0
                          ? AppTheme.warningLight
                          : AppTheme.successLight,
                    ),
                  ],
                ),

                SizedBox(height: 3.w),

                // Action Buttons
                Row(
                  children: [
                    _buildActionButton(
                      icon: 'photo_library',
                      label: '${inspection["photoCount"]} photos',
                      onTap: onViewPhotos,
                    ),
                    SizedBox(width: 3.w),
                    _buildActionButton(
                      icon: 'description',
                      label: 'Rapport',
                      onTap: onViewReport,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => _showQuickActions(context),
                      icon: CustomIconWidget(
                        iconName: 'more_vert',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
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

  Widget _buildStatusBadge(String status, Color color) {
    String statusText;
    switch (status) {
      case 'passed':
        statusText = 'Conforme';
        break;
      case 'warning':
        statusText = 'Attention';
        break;
      case 'failed':
        statusText = 'Non conforme';
        break;
      default:
        statusText = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        statusText,
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildMetricChip({
    required String icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: color,
            size: 14,
          ),
          SizedBox(width: 1.w),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 90) return AppTheme.successLight;
    if (score >= 75) return AppTheme.warningLight;
    return AppTheme.errorLight;
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Actions rapides',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 3.h),
            _buildQuickActionTile(
              context,
              icon: 'visibility',
              title: 'Voir le rapport',
              onTap: () {
                Navigator.pop(context);
                onViewReport();
              },
            ),
            _buildQuickActionTile(
              context,
              icon: 'photo_library',
              title: 'Voir les photos',
              onTap: () {
                Navigator.pop(context);
                onViewPhotos();
              },
            ),
            _buildQuickActionTile(
              context,
              icon: 'share',
              title: 'Partager',
              onTap: () {
                Navigator.pop(context);
                onShare();
              },
            ),
            _buildQuickActionTile(
              context,
              icon: 'schedule',
              title: 'Planifier un suivi',
              onTap: () {
                Navigator.pop(context);
                onScheduleFollowUp();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionTile(
    BuildContext context, {
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: AppTheme.lightTheme.colorScheme.primary,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
