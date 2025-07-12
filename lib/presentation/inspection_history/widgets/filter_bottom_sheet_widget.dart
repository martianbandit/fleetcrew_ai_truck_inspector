import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> activeFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const FilterBottomSheetWidget({
    Key? key,
    required this.activeFilters,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _tempFilters;
  DateTimeRange? _selectedDateRange;

  final List<Map<String, dynamic>> _statusOptions = [
    {"value": "passed", "label": "Conforme", "color": AppTheme.successLight},
    {"value": "warning", "label": "Attention", "color": AppTheme.warningLight},
    {"value": "failed", "label": "Non conforme", "color": AppTheme.errorLight},
  ];

  final List<Map<String, dynamic>> _inspectorOptions = [
    {"value": "INS-001", "label": "Jean-Pierre Dubois"},
    {"value": "INS-002", "label": "Marie-Claire Tremblay"},
    {"value": "INS-003", "label": "François Leblanc"},
    {"value": "INS-004", "label": "Sophie Gagnon"},
    {"value": "INS-005", "label": "Michel Bouchard"},
  ];

  final List<Map<String, dynamic>> _inspectionTypeOptions = [
    {"value": "complete", "label": "Inspection complète"},
    {"value": "routine", "label": "Inspection de routine"},
    {"value": "safety", "label": "Inspection de sécurité"},
    {"value": "maintenance", "label": "Inspection de maintenance"},
  ];

  @override
  void initState() {
    super.initState();
    _tempFilters = Map.from(widget.activeFilters);

    if (_tempFilters["dateRange"] != null) {
      final dateRange = _tempFilters["dateRange"] as Map<String, DateTime>;
      _selectedDateRange = DateTimeRange(
        start: dateRange["start"]!,
        end: dateRange["end"]!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  'Filtres',
                  style: AppTheme.lightTheme.textTheme.headlineSmall,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _tempFilters.clear();
                      _selectedDateRange = null;
                    });
                  },
                  child: const Text('Effacer tout'),
                ),
              ],
            ),
          ),

          // Filter Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Range Filter
                  _buildFilterSection(
                    title: 'Période',
                    child: _buildDateRangeFilter(),
                  ),

                  SizedBox(height: 4.h),

                  // Status Filter
                  _buildFilterSection(
                    title: 'Statut',
                    child: _buildStatusFilter(),
                  ),

                  SizedBox(height: 4.h),

                  // Inspector Filter
                  _buildFilterSection(
                    title: 'Inspecteur',
                    child: _buildInspectorFilter(),
                  ),

                  SizedBox(height: 4.h),

                  // Inspection Type Filter
                  _buildFilterSection(
                    title: 'Type d\'inspection',
                    child: _buildInspectionTypeFilter(),
                  ),

                  SizedBox(height: 4.h),

                  // Compliance Score Filter
                  _buildFilterSection(
                    title: 'Score de conformité',
                    child: _buildComplianceScoreFilter(),
                  ),

                  SizedBox(height: 6.h),
                ],
              ),
            ),
          ),

          // Action Buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onFiltersChanged(_tempFilters);
                      Navigator.pop(context);
                    },
                    child: const Text('Appliquer'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        child,
      ],
    );
  }

  Widget _buildDateRangeFilter() {
    return InkWell(
      onTap: _selectDateRange,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'date_range',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                _selectedDateRange != null
                    ? '${_selectedDateRange!.start.day}/${_selectedDateRange!.start.month}/${_selectedDateRange!.start.year} - ${_selectedDateRange!.end.day}/${_selectedDateRange!.end.month}/${_selectedDateRange!.end.year}'
                    : 'Sélectionner une période',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: _selectedDateRange != null
                      ? AppTheme.lightTheme.colorScheme.onSurface
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (_selectedDateRange != null)
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedDateRange = null;
                    _tempFilters.remove("dateRange");
                  });
                },
                icon: CustomIconWidget(
                  iconName: 'clear',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: _statusOptions.map((option) {
        final isSelected = _tempFilters["status"] == option["value"];
        return FilterChip(
          selected: isSelected,
          label: Text(option["label"]),
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _tempFilters["status"] = option["value"];
              } else {
                _tempFilters.remove("status");
              }
            });
          },
          selectedColor: (option["color"] as Color).withValues(alpha: 0.2),
          checkmarkColor: option["color"],
          labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            color: isSelected ? option["color"] : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInspectorFilter() {
    return Column(
      children: _inspectorOptions.map((option) {
        final isSelected = _tempFilters["inspector"] == option["value"];
        return CheckboxListTile(
          value: isSelected,
          onChanged: (selected) {
            setState(() {
              if (selected == true) {
                _tempFilters["inspector"] = option["value"];
              } else {
                _tempFilters.remove("inspector");
              }
            });
          },
          title: Text(
            option["label"],
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  Widget _buildInspectionTypeFilter() {
    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: _inspectionTypeOptions.map((option) {
        final isSelected = _tempFilters["inspectionType"] == option["value"];
        return FilterChip(
          selected: isSelected,
          label: Text(option["label"]),
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _tempFilters["inspectionType"] = option["value"];
              } else {
                _tempFilters.remove("inspectionType");
              }
            });
          },
          selectedColor:
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
          checkmarkColor: AppTheme.lightTheme.colorScheme.primary,
        );
      }).toList(),
    );
  }

  Widget _buildComplianceScoreFilter() {
    final currentRange = _tempFilters["complianceRange"] as RangeValues? ??
        const RangeValues(0, 100);

    return Column(
      children: [
        RangeSlider(
          values: currentRange,
          min: 0,
          max: 100,
          divisions: 20,
          labels: RangeLabels(
            '${currentRange.start.round()}%',
            '${currentRange.end.round()}%',
          ),
          onChanged: (values) {
            setState(() {
              _tempFilters["complianceRange"] = values;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${currentRange.start.round()}%',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            Text(
              '${currentRange.end.round()}%',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
      locale: const Locale('fr', 'CA'),
      builder: (context, child) {
        return Theme(
          data: AppTheme.lightTheme.copyWith(
            datePickerTheme: DatePickerThemeData(
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              headerBackgroundColor: AppTheme.lightTheme.colorScheme.primary,
              headerForegroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.lightTheme.colorScheme.onPrimary;
                }
                return AppTheme.lightTheme.colorScheme.onSurface;
              }),
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.lightTheme.colorScheme.primary;
                }
                return null;
              }),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
        _tempFilters["dateRange"] = {
          "start": picked.start,
          "end": picked.end,
        };
      });
    }
  }
}
