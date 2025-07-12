import 'package:flutter/material.dart';
import '../presentation/fleet_dashboard/fleet_dashboard.dart';
import '../presentation/settings/settings.dart';
import '../presentation/vehicle_selection/vehicle_selection.dart';
import '../presentation/measurement_detail/measurement_detail.dart';
import '../presentation/interactive_truck_schematic/interactive_truck_schematic.dart';
import '../presentation/inspection_history/inspection_history.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String fleetDashboard = '/fleet-dashboard';
  static const String settings = '/settings';
  static const String vehicleSelection = '/vehicle-selection';
  static const String measurementDetail = '/measurement-detail';
  static const String interactiveTruckSchematic =
      '/interactive-truck-schematic';
  static const String inspectionHistory = '/inspection-history';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const FleetDashboard(),
    fleetDashboard: (context) => const FleetDashboard(),
    settings: (context) => const Settings(),
    vehicleSelection: (context) => const VehicleSelection(),
    measurementDetail: (context) => const MeasurementDetail(),
    interactiveTruckSchematic: (context) => const InteractiveTruckSchematic(),
    inspectionHistory: (context) => const InspectionHistory(),
    // TODO: Add your other routes here
  };
}
