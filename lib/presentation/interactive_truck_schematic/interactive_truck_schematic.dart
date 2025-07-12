import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_tabs_widget.dart';
import './widgets/floating_toolbar_widget.dart';
import './widgets/measurement_bottom_sheet.dart';
import './widgets/measurement_point_widget.dart';
import './widgets/truck_schematic_painter.dart';

class InteractiveTruckSchematic extends StatefulWidget {
  const InteractiveTruckSchematic({Key? key}) : super(key: key);

  @override
  State<InteractiveTruckSchematic> createState() =>
      _InteractiveTruckSchematicState();
}

class _InteractiveTruckSchematicState extends State<InteractiveTruckSchematic>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TransformationController _transformationController;
  late AnimationController _zoomAnimationController;

  String _selectedCategory = 'Tires';
  bool _isMetricUnits = true;
  double _completionPercentage = 0.0;

  final List<String> _categories = [
    'Tires',
    'Engine',
    'Brakes',
    'Lights',
    'Fluids'
  ];

  // Mock measurement data
  final List<Map<String, dynamic>> _measurementPoints = [
    {
      "id": "tire_fl",
      "category": "Tires",
      "name": "Pneu avant gauche",
      "position": {"x": 0.25, "y": 0.7},
      "status": "passed",
      "currentValue": 35.2,
      "unit": "PSI",
      "minValue": 32.0,
      "maxValue": 38.0,
      "lastMeasured": "2025-07-11 21:45:00",
      "hasPhoto": true,
      "isLive": true,
    },
    {
      "id": "tire_fr",
      "category": "Tires",
      "name": "Pneu avant droit",
      "position": {"x": 0.75, "y": 0.7},
      "status": "warning",
      "currentValue": 30.8,
      "unit": "PSI",
      "minValue": 32.0,
      "maxValue": 38.0,
      "lastMeasured": "2025-07-11 21:44:30",
      "hasPhoto": false,
      "isLive": true,
    },
    {
      "id": "tire_rl",
      "category": "Tires",
      "name": "Pneu arrière gauche",
      "position": {"x": 0.25, "y": 0.3},
      "status": "failed",
      "currentValue": 28.5,
      "unit": "PSI",
      "minValue": 32.0,
      "maxValue": 38.0,
      "lastMeasured": "2025-07-11 21:43:15",
      "hasPhoto": true,
      "isLive": true,
    },
    {
      "id": "tire_rr",
      "category": "Tires",
      "name": "Pneu arrière droit",
      "position": {"x": 0.75, "y": 0.3},
      "status": "not_measured",
      "currentValue": null,
      "unit": "PSI",
      "minValue": 32.0,
      "maxValue": 38.0,
      "lastMeasured": null,
      "hasPhoto": false,
      "isLive": false,
    },
    {
      "id": "engine_temp",
      "category": "Engine",
      "name": "Température moteur",
      "position": {"x": 0.5, "y": 0.85},
      "status": "passed",
      "currentValue": 92.5,
      "unit": "°C",
      "minValue": 85.0,
      "maxValue": 105.0,
      "lastMeasured": "2025-07-11 21:46:12",
      "hasPhoto": false,
      "isLive": true,
    },
    {
      "id": "engine_oil",
      "category": "Engine",
      "name": "Pression huile",
      "position": {"x": 0.45, "y": 0.8},
      "status": "warning",
      "currentValue": 2.8,
      "unit": "bar",
      "minValue": 3.0,
      "maxValue": 6.0,
      "lastMeasured": "2025-07-11 21:45:45",
      "hasPhoto": true,
      "isLive": false,
    },
    {
      "id": "brake_fl",
      "category": "Brakes",
      "name": "Frein avant gauche",
      "position": {"x": 0.2, "y": 0.72},
      "status": "passed",
      "currentValue": 8.2,
      "unit": "mm",
      "minValue": 6.0,
      "maxValue": 12.0,
      "lastMeasured": "2025-07-11 21:42:30",
      "hasPhoto": true,
      "isLive": false,
    },
    {
      "id": "light_headlight_l",
      "category": "Lights",
      "name": "Phare avant gauche",
      "position": {"x": 0.15, "y": 0.9},
      "status": "passed",
      "currentValue": 1.0,
      "unit": "lux",
      "minValue": 0.8,
      "maxValue": 1.5,
      "lastMeasured": "2025-07-11 21:41:15",
      "hasPhoto": false,
      "isLive": false,
    },
    {
      "id": "fluid_coolant",
      "category": "Fluids",
      "name": "Liquide de refroidissement",
      "position": {"x": 0.55, "y": 0.82},
      "status": "warning",
      "currentValue": 65.0,
      "unit": "%",
      "minValue": 70.0,
      "maxValue": 100.0,
      "lastMeasured": "2025-07-11 21:40:00",
      "hasPhoto": false,
      "isLive": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _transformationController = TransformationController();
    _zoomAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedCategory = _categories[_tabController.index];
        });
      }
    });

    _calculateCompletionPercentage();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _transformationController.dispose();
    _zoomAnimationController.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  void _calculateCompletionPercentage() {
    final totalPoints = _measurementPoints.length;
    final measuredPoints = _measurementPoints
        .where((point) => point["status"] != "not_measured")
        .length;

    setState(() {
      _completionPercentage =
          totalPoints > 0 ? measuredPoints / totalPoints : 0.0;
    });
  }

  List<Map<String, dynamic>> _getFilteredMeasurementPoints() {
    return _measurementPoints
        .where((point) => point["category"] == _selectedCategory)
        .toList();
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

  void _onMeasurementPointTap(Map<String, dynamic> point) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MeasurementBottomSheet(
        measurementPoint: point,
        isMetricUnits: _isMetricUnits,
        onMeasurementUpdated: (updatedPoint) {
          setState(() {
            final index = _measurementPoints
                .indexWhere((p) => p["id"] == updatedPoint["id"]);
            if (index != -1) {
              _measurementPoints[index] = updatedPoint;
              _calculateCompletionPercentage();
            }
          });
        },
      ),
    );
  }

  void _onMeasurementPointLongPress(Map<String, dynamic> point) {
    HapticFeedback.mediumImpact();
    Navigator.pushNamed(context, '/measurement-detail', arguments: point);
  }

  void _toggleUnits() {
    setState(() {
      _isMetricUnits = !_isMetricUnits;
    });
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  void _zoomIn() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    if (currentScale < 3.0) {
      _transformationController.value = Matrix4.identity()
        ..scale(currentScale * 1.2);
    }
  }

  void _zoomOut() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    if (currentScale > 0.5) {
      _transformationController.value = Matrix4.identity()
        ..scale(currentScale * 0.8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Schéma Interactif',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/inspection-history'),
            icon: CustomIconWidget(
              iconName: 'history',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 24,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Floating Toolbar
            FloatingToolbarWidget(
              completionPercentage: _completionPercentage,
              isMetricUnits: _isMetricUnits,
              onToggleUnits: _toggleUnits,
              onZoomIn: _zoomIn,
              onZoomOut: _zoomOut,
              onResetZoom: _resetZoom,
            ),

            // Main Schematic Area
            Expanded(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.shadow,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: InteractiveViewer(
                    transformationController: _transformationController,
                    minScale: 0.5,
                    maxScale: 3.0,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Stack(
                        children: [
                          // Truck Schematic Background
                          Positioned.fill(
                            child: CustomPaint(
                              painter: TruckSchematicPainter(
                                selectedCategory: _selectedCategory,
                              ),
                            ),
                          ),

                          // Measurement Points Overlay
                          ..._getFilteredMeasurementPoints().map((point) {
                            final position =
                                point["position"] as Map<String, dynamic>;
                            return Positioned(
                              left: (position["x"] as double) * 100.w - 20,
                              top: (position["y"] as double) * 60.h - 20,
                              child: MeasurementPointWidget(
                                measurementPoint: point,
                                statusColor:
                                    _getStatusColor(point["status"] as String),
                                onTap: () => _onMeasurementPointTap(point),
                                onLongPress: () =>
                                    _onMeasurementPointLongPress(point),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Category Navigation Tabs
            CategoryTabsWidget(
              categories: _categories,
              selectedCategory: _selectedCategory,
              tabController: _tabController,
              onCategoryChanged: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/fleet-dashboard'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        child: CustomIconWidget(
          iconName: 'dashboard',
          color: AppTheme.lightTheme.colorScheme.onTertiary,
          size: 24,
        ),
      ),
    );
  }
}
