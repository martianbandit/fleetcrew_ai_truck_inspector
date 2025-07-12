import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategoryTabsWidget extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final TabController tabController;
  final Function(String) onCategoryChanged;

  const CategoryTabsWidget({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.tabController,
    required this.onCategoryChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Tab Bar
          Container(
            height: 6.h,
            child: TabBar(
              controller: tabController,
              isScrollable: true,
              indicatorColor: AppTheme.lightTheme.colorScheme.primary,
              labelColor: AppTheme.lightTheme.colorScheme.primary,
              unselectedLabelColor: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
              labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: AppTheme.lightTheme.textTheme.labelMedium,
              tabs: categories.map((category) {
                return Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: _getCategoryIcon(category),
                        color: selectedCategory == category
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                        size: 20,
                      ),
                      SizedBox(width: 1.w),
                      Text(category),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // Category Info
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(selectedCategory)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: _getCategoryIcon(selectedCategory),
                      color: _getCategoryColor(selectedCategory),
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          selectedCategory,
                          style: AppTheme.lightTheme.textTheme.titleSmall,
                        ),
                        Text(
                          _getCategoryDescription(selectedCategory),
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_getCategoryPointCount(selectedCategory)} points',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryIcon(String category) {
    switch (category) {
      case 'Tires':
        return 'tire_repair';
      case 'Engine':
        return 'settings';
      case 'Brakes':
        return 'disc_full';
      case 'Lights':
        return 'lightbulb';
      case 'Fluids':
        return 'opacity';
      default:
        return 'category';
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
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

  String _getCategoryDescription(String category) {
    switch (category) {
      case 'Tires':
        return 'Pression et état des pneus avec données TPMS en temps réel';
      case 'Engine':
        return 'Température, pression huile et diagnostics moteur';
      case 'Brakes':
        return 'Épaisseur des plaquettes et système de freinage';
      case 'Lights':
        return 'Phares, feux arrière et éclairage de sécurité';
      case 'Fluids':
        return 'Niveaux de liquides et systèmes hydrauliques';
      default:
        return 'Points de mesure pour cette catégorie';
    }
  }

  int _getCategoryPointCount(String category) {
    // Mock data - in real app, this would count actual measurement points
    switch (category) {
      case 'Tires':
        return 4;
      case 'Engine':
        return 2;
      case 'Brakes':
        return 1;
      case 'Lights':
        return 1;
      case 'Fluids':
        return 1;
      default:
        return 0;
    }
  }
}
