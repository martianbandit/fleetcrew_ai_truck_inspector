import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/inspection_card_widget.dart';
import './widgets/trend_analysis_widget.dart';

class InspectionHistory extends StatefulWidget {
  const InspectionHistory({Key? key}) : super(key: key);

  @override
  State<InspectionHistory> createState() => _InspectionHistoryState();
}

class _InspectionHistoryState extends State<InspectionHistory>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _isRefreshing = false;
  String _searchQuery = '';
  Map<String, dynamic> _activeFilters = {};

  // Mock inspection data
  final List<Map<String, dynamic>> _inspectionHistory = [
    {
      "id": "INS-2025-001",
      "vehicleId": "TRK-4521",
      "unitNumber": "4521",
      "vehicleThumbnail":
          "https://images.pexels.com/photos/1335077/pexels-photo-1335077.jpeg?auto=compress&cs=tinysrgb&w=400",
      "inspectionDate": DateTime(2025, 1, 11, 14, 30),
      "inspectorName": "Jean-Pierre Dubois",
      "inspectorId": "INS-001",
      "status": "passed",
      "inspectionType": "Inspection complète",
      "location": "Montréal, QC",
      "duration": "45 min",
      "issuesFound": 0,
      "complianceScore": 98.5,
      "nextInspectionDue": DateTime(2025, 4, 11),
      "reportUrl": "/reports/INS-2025-001.pdf",
      "photoCount": 12,
      "measurements": {
        "tirePressure": "Conforme",
        "brakeSystem": "Excellent",
        "lights": "Fonctionnel",
        "engine": "Optimal"
      }
    },
    {
      "id": "INS-2025-002",
      "vehicleId": "TRK-3847",
      "unitNumber": "3847",
      "vehicleThumbnail":
          "https://images.pexels.com/photos/1335077/pexels-photo-1335077.jpeg?auto=compress&cs=tinysrgb&w=400",
      "inspectionDate": DateTime(2025, 1, 10, 9, 15),
      "inspectorName": "Marie-Claire Tremblay",
      "inspectorId": "INS-002",
      "status": "warning",
      "inspectionType": "Inspection de routine",
      "location": "Québec, QC",
      "duration": "32 min",
      "issuesFound": 2,
      "complianceScore": 85.2,
      "nextInspectionDue": DateTime(2025, 2, 10),
      "reportUrl": "/reports/INS-2025-002.pdf",
      "photoCount": 8,
      "measurements": {
        "tirePressure": "Attention requise",
        "brakeSystem": "Bon",
        "lights": "Fonctionnel",
        "engine": "Bon"
      }
    },
    {
      "id": "INS-2025-003",
      "vehicleId": "TRK-2156",
      "unitNumber": "2156",
      "vehicleThumbnail":
          "https://images.pexels.com/photos/1335077/pexels-photo-1335077.jpeg?auto=compress&cs=tinysrgb&w=400",
      "inspectionDate": DateTime(2025, 1, 9, 16, 45),
      "inspectorName": "François Leblanc",
      "inspectorId": "INS-003",
      "status": "failed",
      "inspectionType": "Inspection de sécurité",
      "location": "Laval, QC",
      "duration": "67 min",
      "issuesFound": 5,
      "complianceScore": 62.8,
      "nextInspectionDue": DateTime(2025, 1, 16),
      "reportUrl": "/reports/INS-2025-003.pdf",
      "photoCount": 15,
      "measurements": {
        "tirePressure": "Critique",
        "brakeSystem": "Attention requise",
        "lights": "Défaillant",
        "engine": "Attention requise"
      }
    },
    {
      "id": "INS-2025-004",
      "vehicleId": "TRK-5893",
      "unitNumber": "5893",
      "vehicleThumbnail":
          "https://images.pexels.com/photos/1335077/pexels-photo-1335077.jpeg?auto=compress&cs=tinysrgb&w=400",
      "inspectionDate": DateTime(2025, 1, 8, 11, 20),
      "inspectorName": "Sophie Gagnon",
      "inspectorId": "INS-004",
      "status": "passed",
      "inspectionType": "Inspection complète",
      "location": "Sherbrooke, QC",
      "duration": "38 min",
      "issuesFound": 1,
      "complianceScore": 92.1,
      "nextInspectionDue": DateTime(2025, 4, 8),
      "reportUrl": "/reports/INS-2025-004.pdf",
      "photoCount": 10,
      "measurements": {
        "tirePressure": "Conforme",
        "brakeSystem": "Excellent",
        "lights": "Fonctionnel",
        "engine": "Bon"
      }
    },
    {
      "id": "INS-2025-005",
      "vehicleId": "TRK-7234",
      "unitNumber": "7234",
      "vehicleThumbnail":
          "https://images.pexels.com/photos/1335077/pexels-photo-1335077.jpeg?auto=compress&cs=tinysrgb&w=400",
      "inspectionDate": DateTime(2025, 1, 7, 13, 10),
      "inspectorName": "Michel Bouchard",
      "inspectorId": "INS-005",
      "status": "passed",
      "inspectionType": "Inspection de routine",
      "location": "Trois-Rivières, QC",
      "duration": "29 min",
      "issuesFound": 0,
      "complianceScore": 96.7,
      "nextInspectionDue": DateTime(2025, 4, 7),
      "reportUrl": "/reports/INS-2025-005.pdf",
      "photoCount": 7,
      "measurements": {
        "tirePressure": "Conforme",
        "brakeSystem": "Excellent",
        "lights": "Fonctionnel",
        "engine": "Optimal"
      }
    }
  ];

  List<Map<String, dynamic>> get _filteredInspections {
    List<Map<String, dynamic>> filtered = List.from(_inspectionHistory);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((inspection) {
        final query = _searchQuery.toLowerCase();
        return (inspection["unitNumber"] as String)
                .toLowerCase()
                .contains(query) ||
            (inspection["inspectorName"] as String)
                .toLowerCase()
                .contains(query) ||
            (inspection["id"] as String).toLowerCase().contains(query);
      }).toList();
    }

    // Apply additional filters
    if (_activeFilters.isNotEmpty) {
      if (_activeFilters["status"] != null) {
        filtered = filtered
            .where((inspection) =>
                inspection["status"] == _activeFilters["status"])
            .toList();
      }

      if (_activeFilters["inspector"] != null) {
        filtered = filtered
            .where((inspection) =>
                inspection["inspectorId"] == _activeFilters["inspector"])
            .toList();
      }

      if (_activeFilters["dateRange"] != null) {
        final dateRange = _activeFilters["dateRange"] as Map<String, DateTime>;
        filtered = filtered.where((inspection) {
          final inspectionDate = inspection["inspectionDate"] as DateTime;
          return inspectionDate.isAfter(dateRange["start"]!) &&
              inspectionDate.isBefore(dateRange["end"]!);
        }).toList();
      }
    }

    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        activeFilters: _activeFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _activeFilters = filters;
          });
        },
      ),
    );
  }

  void _exportData() {
    // Show export options
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Exporter les données',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'picture_as_pdf',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Rapport PDF'),
              onTap: () {
                Navigator.pop(context);
                // Handle PDF export
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'table_chart',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Fichier CSV'),
              onTap: () {
                Navigator.pop(context);
                // Handle CSV export
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ],
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
        title: Text(
          'Historique des Inspections',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _exportData,
            icon: CustomIconWidget(
              iconName: 'file_download',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 24,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.lightTheme.colorScheme.onPrimary,
          labelColor: AppTheme.lightTheme.colorScheme.onPrimary,
          unselectedLabelColor:
              AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.7),
          tabs: const [
            Tab(text: 'Tableau de bord'),
            Tab(text: 'Historique'),
            Tab(text: 'Analyses'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Dashboard Tab
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'dashboard',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 48,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Tableau de bord',
                  style: AppTheme.lightTheme.textTheme.headlineSmall,
                ),
                SizedBox(height: 1.h),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/fleet-dashboard'),
                  child: const Text('Aller au tableau de bord'),
                ),
              ],
            ),
          ),

          // History Tab (Active)
          Column(
            children: [
              // Search and Filter Section
              Container(
                padding: EdgeInsets.all(4.w),
                color: AppTheme.lightTheme.colorScheme.surface,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Rechercher par numéro, inspecteur...',
                              prefixIcon: CustomIconWidget(
                                iconName: 'search',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() {
                                          _searchQuery = '';
                                        });
                                      },
                                      icon: CustomIconWidget(
                                        iconName: 'clear',
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                        size: 20,
                                      ),
                                    )
                                  : null,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                                vertical: 1.h,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Container(
                          decoration: BoxDecoration(
                            color: _activeFilters.isNotEmpty
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline,
                            ),
                          ),
                          child: IconButton(
                            onPressed: _showFilterBottomSheet,
                            icon: CustomIconWidget(
                              iconName: 'filter_list',
                              color: _activeFilters.isNotEmpty
                                  ? AppTheme.lightTheme.colorScheme.onPrimary
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_activeFilters.isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Text(
                            'Filtres actifs: ${_activeFilters.length}',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _activeFilters.clear();
                              });
                            },
                            child: const Text('Effacer tout'),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Inspection List
              Expanded(
                child: _filteredInspections.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _refreshData,
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.all(4.w),
                          itemCount: _filteredInspections.length +
                              (_isLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _filteredInspections.length) {
                              return _buildLoadingIndicator();
                            }

                            final inspection = _filteredInspections[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 3.w),
                              child: InspectionCardWidget(
                                inspection: inspection,
                                onTap: () =>
                                    _navigateToInspectionDetail(inspection),
                                onViewReport: () => _viewReport(inspection),
                                onViewPhotos: () => _viewPhotos(inspection),
                                onShare: () => _shareInspection(inspection),
                                onScheduleFollowUp: () =>
                                    _scheduleFollowUp(inspection),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),

          // Trend Analysis Tab
          TrendAnalysisWidget(inspectionHistory: _inspectionHistory),
        ],
      ),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton.extended(
              onPressed: () =>
                  Navigator.pushNamed(context, '/vehicle-selection'),
              backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onTertiary,
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onTertiary,
                size: 24,
              ),
              label: const Text('Nouvelle inspection'),
            )
          : null,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'assignment',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 3.h),
          Text(
            _searchQuery.isNotEmpty || _activeFilters.isNotEmpty
                ? 'Aucun résultat trouvé'
                : 'Aucune inspection enregistrée',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            _searchQuery.isNotEmpty || _activeFilters.isNotEmpty
                ? 'Essayez de modifier vos critères de recherche'
                : 'Commencez votre première inspection',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          if (_searchQuery.isEmpty && _activeFilters.isEmpty)
            ElevatedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, '/vehicle-selection'),
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 20,
              ),
              label: const Text('Commencer une inspection'),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Center(
        child: CircularProgressIndicator(
          color: AppTheme.lightTheme.colorScheme.primary,
        ),
      ),
    );
  }

  void _navigateToInspectionDetail(Map<String, dynamic> inspection) {
    Navigator.pushNamed(
      context,
      '/measurement-detail',
      arguments: inspection,
    );
  }

  void _viewReport(Map<String, dynamic> inspection) {
    // Handle view report action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ouverture du rapport ${inspection["id"]}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _viewPhotos(Map<String, dynamic> inspection) {
    // Handle view photos action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Affichage des ${inspection["photoCount"]} photos'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _shareInspection(Map<String, dynamic> inspection) {
    // Handle share inspection action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Partage de l\'inspection ${inspection["id"]}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _scheduleFollowUp(Map<String, dynamic> inspection) {
    // Handle schedule follow-up action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Planification du suivi pour ${inspection["unitNumber"]}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }
}
