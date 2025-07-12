import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/scanner_overlay_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/vehicle_card_widget.dart';

class VehicleSelection extends StatefulWidget {
  const VehicleSelection({Key? key}) : super(key: key);

  @override
  State<VehicleSelection> createState() => _VehicleSelectionState();
}

class _VehicleSelectionState extends State<VehicleSelection> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _isSearching = false;
  bool _showScanner = false;
  bool _isNfcActive = false;
  String _searchQuery = '';
  List<Map<String, dynamic>> _filteredVehicles = [];

  // Mock vehicle data
  final List<Map<String, dynamic>> _vehicles = [
    {
      "id": "VH001",
      "unitNumber": "FL-2024-001",
      "make": "Volvo",
      "model": "VNL 860",
      "year": 2023,
      "vin": "1FUJGHDV8NLAA1234",
      "imageUrl":
          "https://images.pexels.com/photos/1118448/pexels-photo-1118448.jpeg?auto=compress&cs=tinysrgb&w=800",
      "lastInspection": DateTime.now().subtract(Duration(days: 15)),
      "status": "compliant",
      "nextInspectionDue": DateTime.now().add(Duration(days: 75)),
      "mileage": 125430,
      "location": "Montréal, QC",
      "driver": "Jean Tremblay"
    },
    {
      "id": "VH002",
      "unitNumber": "FL-2024-002",
      "make": "Freightliner",
      "model": "Cascadia",
      "year": 2022,
      "vin": "1FUJGHDV8NLAA5678",
      "imageUrl":
          "https://images.pexels.com/photos/1118448/pexels-photo-1118448.jpeg?auto=compress&cs=tinysrgb&w=800",
      "lastInspection": DateTime.now().subtract(Duration(days: 85)),
      "status": "due_soon",
      "nextInspectionDue": DateTime.now().add(Duration(days: 5)),
      "mileage": 98750,
      "location": "Québec, QC",
      "driver": "Marie Dubois"
    },
    {
      "id": "VH003",
      "unitNumber": "FL-2024-003",
      "make": "Peterbilt",
      "model": "579",
      "year": 2021,
      "vin": "1FUJGHDV8NLAA9012",
      "imageUrl":
          "https://images.pexels.com/photos/1118448/pexels-photo-1118448.jpeg?auto=compress&cs=tinysrgb&w=800",
      "lastInspection": DateTime.now().subtract(Duration(days: 95)),
      "status": "overdue",
      "nextInspectionDue": DateTime.now().subtract(Duration(days: 5)),
      "mileage": 156890,
      "location": "Laval, QC",
      "driver": "Pierre Gagnon"
    },
    {
      "id": "VH004",
      "unitNumber": "FL-2024-004",
      "make": "Kenworth",
      "model": "T680",
      "year": 2023,
      "vin": "1FUJGHDV8NLAA3456",
      "imageUrl":
          "https://images.pexels.com/photos/1118448/pexels-photo-1118448.jpeg?auto=compress&cs=tinysrgb&w=800",
      "lastInspection": DateTime.now().subtract(Duration(days: 30)),
      "status": "compliant",
      "nextInspectionDue": DateTime.now().add(Duration(days: 60)),
      "mileage": 87650,
      "location": "Sherbrooke, QC",
      "driver": "Luc Bouchard"
    },
    {
      "id": "VH005",
      "unitNumber": "FL-2024-005",
      "make": "Mack",
      "model": "Anthem",
      "year": 2022,
      "vin": "1FUJGHDV8NLAA7890",
      "imageUrl":
          "https://images.pexels.com/photos/1118448/pexels-photo-1118448.jpeg?auto=compress&cs=tinysrgb&w=800",
      "lastInspection": DateTime.now().subtract(Duration(days: 78)),
      "status": "due_soon",
      "nextInspectionDue": DateTime.now().add(Duration(days: 12)),
      "mileage": 134200,
      "location": "Trois-Rivières, QC",
      "driver": "Sophie Leblanc"
    }
  ];

  @override
  void initState() {
    super.initState();
    _filteredVehicles = _vehicles;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _isSearching = _searchQuery.isNotEmpty;
      _filterVehicles();
    });
  }

  void _filterVehicles() {
    if (_searchQuery.isEmpty) {
      _filteredVehicles = _vehicles;
    } else {
      _filteredVehicles = _vehicles.where((vehicle) {
        final query = _searchQuery.toLowerCase();
        return (vehicle["unitNumber"] as String)
                .toLowerCase()
                .contains(query) ||
            (vehicle["make"] as String).toLowerCase().contains(query) ||
            (vehicle["model"] as String).toLowerCase().contains(query) ||
            (vehicle["vin"] as String).toLowerCase().contains(query);
      }).toList();
    }
  }

  Future<void> _refreshVehicles() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  void _openBarcodeScanner() {
    setState(() {
      _showScanner = true;
    });
  }

  void _closeBarcodeScanner() {
    setState(() {
      _showScanner = false;
    });
  }

  void _onBarcodeScanned(String barcode) {
    _closeBarcodeScanner();
    _searchController.text = barcode;
    _filterVehicles();
  }

  void _toggleNfc() {
    setState(() {
      _isNfcActive = !_isNfcActive;
    });

    if (_isNfcActive) {
      // Simulate NFC detection after 3 seconds
      Future.delayed(Duration(seconds: 3), () {
        if (_isNfcActive) {
          _onNfcDetected("FL-2024-002");
        }
      });
    }
  }

  void _onNfcDetected(String unitNumber) {
    setState(() {
      _isNfcActive = false;
    });
    _searchController.text = unitNumber;
    _filterVehicles();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _isSearching = false;
      _filteredVehicles = _vehicles;
    });
  }

  void _onVehicleSelected(Map<String, dynamic> vehicle) {
    Navigator.pushNamed(
      context,
      '/interactive-truck-schematic',
      arguments: vehicle,
    );
  }

  void _showVehicleActions(Map<String, dynamic> vehicle) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
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
              vehicle["unitNumber"] as String,
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            _buildActionTile(
              icon: 'history',
              title: 'Voir l\'historique',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/inspection-history');
              },
            ),
            _buildActionTile(
              icon: 'photo_camera',
              title: 'Photos',
              onTap: () {
                Navigator.pop(context);
                // Handle photos action
              },
            ),
            _buildActionTile(
              icon: 'schedule',
              title: 'Calendrier de maintenance',
              onTap: () {
                Navigator.pop(context);
                // Handle maintenance schedule action
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
        style: AppTheme.lightTheme.textTheme.bodyLarge,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  void _showManualEntryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Ajouter un véhicule',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Numéro d\'unité',
                hintText: 'FL-2024-XXX',
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'Marque',
                hintText: 'Volvo, Freightliner, etc.',
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'Modèle',
                hintText: 'VNL 860, Cascadia, etc.',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle manual entry
            },
            child: Text('Ajouter'),
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
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Text(
          'Sélection de véhicule',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _openBarcodeScanner,
            icon: CustomIconWidget(
              iconName: 'qr_code_scanner',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: _toggleNfc,
            icon: CustomIconWidget(
              iconName: 'nfc',
              color: _isNfcActive
                  ? AppTheme.lightTheme.colorScheme.tertiary
                  : AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: _showManualEntryDialog,
            icon: CustomIconWidget(
              iconName: 'add',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Search Bar
              SearchBarWidget(
                controller: _searchController,
                isSearching: _isSearching,
                onClear: _clearSearch,
              ),

              // NFC Active Indicator
              if (_isNfcActive)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.1),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'nfc',
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Approchez le téléphone du tag NFC...',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),
                ),

              // Vehicle List
              Expanded(
                child: _filteredVehicles.isEmpty && _isSearching
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _refreshVehicles,
                        color: AppTheme.lightTheme.colorScheme.primary,
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.all(4.w),
                          itemCount: _filteredVehicles.length,
                          itemBuilder: (context, index) {
                            final vehicle = _filteredVehicles[index];
                            return VehicleCardWidget(
                              vehicle: vehicle,
                              onTap: () => _onVehicleSelected(vehicle),
                              onLongPress: () => _showVehicleActions(vehicle),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),

          // Scanner Overlay
          if (_showScanner)
            ScannerOverlayWidget(
              onClose: _closeBarcodeScanner,
              onBarcodeScanned: _onBarcodeScanned,
            ),

          // Loading Overlay
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'search_off',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Aucun véhicule trouvé',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Essayez de modifier votre recherche',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          TextButton(
            onPressed: _clearSearch,
            child: Text('Effacer les filtres'),
          ),
        ],
      ),
    );
  }
}
