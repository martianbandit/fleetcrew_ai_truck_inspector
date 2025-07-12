import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/alert_card_widget.dart';
import './widgets/inspection_card_widget.dart';
import './widgets/metric_card_widget.dart';

class FleetDashboard extends StatefulWidget {
  const FleetDashboard({super.key});

  @override
  State<FleetDashboard> createState() => _FleetDashboardState();
}

class _FleetDashboardState extends State<FleetDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;

  // Mock data for fleet dashboard
  final List<Map<String, dynamic>> _metricsData = [
    {
      "title": "Véhicules totaux",
      "value": "47",
      "icon": "local_shipping",
      "color": "primary",
      "trend": "+3 ce mois"
    },
    {
      "title": "Inspections actives",
      "value": "12",
      "icon": "assignment",
      "color": "secondary",
      "trend": "En cours"
    },
    {
      "title": "Alertes",
      "value": "5",
      "icon": "warning",
      "color": "warning",
      "trend": "Attention requise"
    },
    {
      "title": "Conformité",
      "value": "94%",
      "icon": "verified",
      "color": "success",
      "trend": "+2% ce mois"
    }
  ];

  final List<Map<String, dynamic>> _recentInspections = [
    {
      "id": "INS-2025-001",
      "vehicleNumber": "FL-4782",
      "inspectorName": "Marc Dubois",
      "status": "completed",
      "timestamp": "Il y a 2 heures",
      "location": "Montréal, QC",
      "issues": 0,
      "photos": 8
    },
    {
      "id": "INS-2025-002",
      "vehicleNumber": "FL-3901",
      "inspectorName": "Sophie Tremblay",
      "status": "pending",
      "timestamp": "Il y a 4 heures",
      "location": "Québec, QC",
      "issues": 2,
      "photos": 5
    },
    {
      "id": "INS-2025-003",
      "vehicleNumber": "FL-5634",
      "inspectorName": "Jean-Pierre Lavoie",
      "status": "failed",
      "timestamp": "Il y a 6 heures",
      "location": "Sherbrooke, QC",
      "issues": 4,
      "photos": 12
    },
    {
      "id": "INS-2025-004",
      "vehicleNumber": "FL-2847",
      "inspectorName": "Marie-Claude Roy",
      "status": "completed",
      "timestamp": "Hier",
      "location": "Trois-Rivières, QC",
      "issues": 1,
      "photos": 6
    }
  ];

  final List<Map<String, dynamic>> _criticalAlerts = [
    {
      "id": "ALT-001",
      "title": "Inspection en retard",
      "description": "FL-2901 - Échéance dépassée de 3 jours",
      "severity": "critical",
      "timestamp": "Il y a 1 heure",
      "vehicleId": "FL-2901"
    },
    {
      "id": "ALT-002",
      "title": "Pression des pneus faible",
      "description": "FL-4782 - Pneu avant gauche: 28 PSI",
      "severity": "warning",
      "timestamp": "Il y a 3 heures",
      "vehicleId": "FL-4782"
    },
    {
      "id": "ALT-003",
      "title": "Maintenance programmée",
      "description": "FL-1456 - Service dans 2 jours",
      "severity": "info",
      "timestamp": "Il y a 5 heures",
      "vehicleId": "FL-1456"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _showInspectionActions(Map<String, dynamic> inspection) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
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
            SizedBox(height: 2.h),
            Text(
              'Actions - ${inspection["vehicleNumber"]}',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            _buildActionTile(
              icon: 'visibility',
              title: 'Voir les détails',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/measurement-detail');
              },
            ),
            _buildActionTile(
              icon: 'photo_library',
              title: 'Photos (${inspection["photos"]})',
              onTap: () {
                Navigator.pop(context);
                // Navigate to photos
              },
            ),
            _buildActionTile(
              icon: 'description',
              title: 'Générer rapport',
              onTap: () {
                Navigator.pop(context);
                // Generate report
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        elevation: 0,
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'local_shipping',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 28,
            ),
            SizedBox(width: 2.w),
            Text(
              'FleetCrew AI',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 2.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'gps_fixed',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 20,
                ),
                SizedBox(width: 1.w),
                CustomIconWidget(
                  iconName: 'bluetooth',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/settings'),
                  child: CustomIconWidget(
                    iconName: 'settings',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.lightTheme.colorScheme.onPrimary,
          unselectedLabelColor:
              AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.7),
          indicatorColor: AppTheme.lightTheme.colorScheme.onPrimary,
          indicatorWeight: 3,
          labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(text: 'Tableau de bord'),
            Tab(text: 'Inspections'),
            Tab(text: 'Véhicules'),
            Tab(text: 'Rapports'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(),
          _buildInspectionsTab(),
          _buildVehiclesTab(),
          _buildReportsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/vehicle-selection'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onTertiary,
        icon: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onTertiary,
          size: 24,
        ),
        label: Text(
          'Nouvelle inspection',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onTertiary,
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Last update timestamp
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'update',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Dernière mise à jour: ${_isRefreshing ? "En cours..." : "11 juil. 2025, 22:24"}',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),

            // Metrics cards
            Text(
              'Vue d\'ensemble',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 3.w,
                mainAxisSpacing: 2.h,
                childAspectRatio: 1.2,
              ),
              itemCount: _metricsData.length,
              itemBuilder: (context, index) {
                return MetricCardWidget(
                  data: _metricsData[index],
                );
              },
            ),
            SizedBox(height: 4.h),

            // Critical alerts
            if (_criticalAlerts.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Alertes critiques',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.error,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_criticalAlerts.length}',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onError,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _criticalAlerts.length,
                separatorBuilder: (context, index) => SizedBox(height: 1.h),
                itemBuilder: (context, index) {
                  return AlertCardWidget(
                    alert: _criticalAlerts[index],
                  );
                },
              ),
              SizedBox(height: 4.h),
            ],

            // Recent inspections
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Inspections récentes',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/inspection-history'),
                  child: Text(
                    'Voir tout',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recentInspections.length,
              separatorBuilder: (context, index) => SizedBox(height: 1.h),
              itemBuilder: (context, index) {
                return InspectionCardWidget(
                  inspection: _recentInspections[index],
                  onTap: () =>
                      _showInspectionActions(_recentInspections[index]),
                );
              },
            ),
            SizedBox(height: 10.h), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildInspectionsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'assignment',
            color: AppTheme.lightTheme.colorScheme.outline,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Inspections',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Gérez vos inspections ici',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehiclesTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'local_shipping',
            color: AppTheme.lightTheme.colorScheme.outline,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Véhicules',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Consultez votre flotte ici',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'assessment',
            color: AppTheme.lightTheme.colorScheme.outline,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Rapports',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Générez vos rapports ici',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
