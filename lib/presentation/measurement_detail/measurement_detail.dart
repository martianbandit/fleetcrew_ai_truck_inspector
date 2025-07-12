import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/historical_chart_widget.dart';
import './widgets/measurement_gauge_widget.dart';
import './widgets/measurement_input_widget.dart';
import './widgets/notes_section_widget.dart';
import './widgets/photo_section_widget.dart';

class MeasurementDetail extends StatefulWidget {
  const MeasurementDetail({Key? key}) : super(key: key);

  @override
  State<MeasurementDetail> createState() => _MeasurementDetailState();
}

class _MeasurementDetailState extends State<MeasurementDetail> {
  final TextEditingController _measurementController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final FocusNode _measurementFocusNode = FocusNode();

  bool _isWithinSpec = true;
  bool _isBluetoothConnected = false;
  bool _isAutoSaveEnabled = true;
  bool _hasUnsavedChanges = false;

  // Mock measurement data
  final Map<String, dynamic> _measurementPoint = {
    "id": "mp_001",
    "name": "Pression des pneus avant gauche",
    "unit": "bar",
    "minValue": 7.5,
    "maxValue": 9.0,
    "currentValue": 8.2,
    "status": "passed",
    "lastMeasured": DateTime.now().subtract(Duration(days: 2)),
    "category": "Pneumatiques"
  };

  final List<Map<String, dynamic>> _photos = [
    {
      "id": "photo_001",
      "url":
          "https://images.pexels.com/photos/190537/pexels-photo-190537.jpeg?auto=compress&cs=tinysrgb&w=800",
      "timestamp": DateTime.now().subtract(Duration(minutes: 5)),
      "description": "Vue générale du pneu"
    },
    {
      "id": "photo_002",
      "url":
          "https://images.pexels.com/photos/3806288/pexels-photo-3806288.jpeg?auto=compress&cs=tinysrgb&w=800",
      "timestamp": DateTime.now().subtract(Duration(minutes: 3)),
      "description": "Détail de la valve"
    }
  ];

  final List<Map<String, dynamic>> _historicalData = [
    {"date": DateTime.now().subtract(Duration(days: 30)), "value": 8.1},
    {"date": DateTime.now().subtract(Duration(days: 25)), "value": 8.3},
    {"date": DateTime.now().subtract(Duration(days: 20)), "value": 8.0},
    {"date": DateTime.now().subtract(Duration(days: 15)), "value": 8.4},
    {"date": DateTime.now().subtract(Duration(days: 10)), "value": 8.2},
    {"date": DateTime.now().subtract(Duration(days: 5)), "value": 8.1},
    {"date": DateTime.now().subtract(Duration(days: 2)), "value": 8.2},
  ];

  @override
  void initState() {
    super.initState();
    _measurementController.text = _measurementPoint["currentValue"].toString();
    _measurementController.addListener(_onMeasurementChanged);
  }

  @override
  void dispose() {
    _measurementController.dispose();
    _notesController.dispose();
    _measurementFocusNode.dispose();
    super.dispose();
  }

  void _onMeasurementChanged() {
    final value = double.tryParse(_measurementController.text);
    if (value != null) {
      setState(() {
        _isWithinSpec = value >= _measurementPoint["minValue"] &&
            value <= _measurementPoint["maxValue"];
        _hasUnsavedChanges = true;
      });
    }
  }

  void _saveData() {
    if (_measurementController.text.isEmpty) return;

    // Simulate save operation
    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mesure enregistrée avec succès'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: Duration(seconds: 2),
      ),
    );

    setState(() {
      _hasUnsavedChanges = false;
    });

    // Return to previous screen after short delay
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.pop(context);
    });
  }

  void _showOutOfSpecDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Valeur hors spécification'),
        content: Text(
            'La valeur saisie (${_measurementController.text} ${_measurementPoint["unit"]}) '
            'est en dehors de la plage acceptable (${_measurementPoint["minValue"]} - ${_measurementPoint["maxValue"]} ${_measurementPoint["unit"]}).\n\n'
            'Voulez-vous continuer ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _saveData();
            },
            child: Text('Confirmer'),
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
        title: Text('Détail de mesure'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            if (_hasUnsavedChanges) {
              _showUnsavedChangesDialog();
            } else {
              Navigator.pop(context);
            }
          },
          icon: CustomIconWidget(
            iconName: 'close',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 24,
          ),
        ),
        actions: [
          if (_isBluetoothConnected)
            Padding(
              padding: EdgeInsets.only(right: 2.w),
              child: CustomIconWidget(
                iconName: 'bluetooth_connected',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 20,
              ),
            ),
          if (_isAutoSaveEnabled)
            Padding(
              padding: EdgeInsets.only(right: 4.w),
              child: CustomIconWidget(
                iconName: 'cloud_sync',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 20,
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 4.h),
            MeasurementInputWidget(
              controller: _measurementController,
              focusNode: _measurementFocusNode,
              unit: _measurementPoint["unit"] as String,
              isWithinSpec: _isWithinSpec,
              onChanged: _onMeasurementChanged,
            ),
            SizedBox(height: 3.h),
            MeasurementGaugeWidget(
              currentValue: double.tryParse(_measurementController.text) ?? 0.0,
              minValue: _measurementPoint["minValue"] as double,
              maxValue: _measurementPoint["maxValue"] as double,
              unit: _measurementPoint["unit"] as String,
              isWithinSpec: _isWithinSpec,
            ),
            SizedBox(height: 4.h),
            PhotoSectionWidget(
              photos: _photos,
              onPhotoAdded: (photo) {
                setState(() {
                  _photos.add(photo);
                  _hasUnsavedChanges = true;
                });
              },
            ),
            SizedBox(height: 4.h),
            HistoricalChartWidget(
              data: _historicalData,
              minValue: _measurementPoint["minValue"] as double,
              maxValue: _measurementPoint["maxValue"] as double,
              unit: _measurementPoint["unit"] as String,
            ),
            SizedBox(height: 4.h),
            NotesSectionWidget(
              controller: _notesController,
              onChanged: () {
                setState(() {
                  _hasUnsavedChanges = true;
                });
              },
            ),
            SizedBox(height: 6.h),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: () {
                if (!_isWithinSpec && _measurementController.text.isNotEmpty) {
                  _showOutOfSpecDialog();
                } else {
                  _saveData();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _hasUnsavedChanges
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.6),
                foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Enregistrer',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _measurementPoint["name"] as String,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.getStatusColor(
                          _measurementPoint["status"] as String)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.getStatusColor(
                        _measurementPoint["status"] as String),
                    width: 1,
                  ),
                ),
                child: Text(
                  _measurementPoint["status"] == "passed"
                      ? "Conforme"
                      : "Non conforme",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.getStatusColor(
                        _measurementPoint["status"] as String),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'category',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                _measurementPoint["category"] as String,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'straighten',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                'Plage acceptable: ${_measurementPoint["minValue"]} - ${_measurementPoint["maxValue"]} ${_measurementPoint["unit"]}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifications non enregistrées'),
        content: Text(
            'Vous avez des modifications non enregistrées. Voulez-vous les perdre ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Ignorer'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _saveData();
            },
            child: Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}
