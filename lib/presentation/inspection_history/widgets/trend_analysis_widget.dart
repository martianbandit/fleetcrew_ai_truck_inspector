import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TrendAnalysisWidget extends StatefulWidget {
  final List<Map<String, dynamic>> inspectionHistory;

  const TrendAnalysisWidget({
    Key? key,
    required this.inspectionHistory,
  }) : super(key: key);

  @override
  State<TrendAnalysisWidget> createState() => _TrendAnalysisWidgetState();
}

class _TrendAnalysisWidgetState extends State<TrendAnalysisWidget> {
  String _selectedPeriod = '7d';
  String _selectedMetric = 'compliance';

  final List<Map<String, String>> _periodOptions = [
    {'value': '7d', 'label': '7 jours'},
    {'value': '30d', 'label': '30 jours'},
    {'value': '90d', 'label': '90 jours'},
    {'value': '1y', 'label': '1 an'},
  ];

  final List<Map<String, String>> _metricOptions = [
    {'value': 'compliance', 'label': 'Conformité'},
    {'value': 'issues', 'label': 'Problèmes'},
    {'value': 'duration', 'label': 'Durée'},
    {'value': 'score', 'label': 'Score'},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Controls
          Row(
            children: [
              Text(
                'Analyses de tendances',
                style: AppTheme.lightTheme.textTheme.headlineSmall,
              ),
              const Spacer(),
              _buildPeriodSelector(),
            ],
          ),

          SizedBox(height: 3.h),

          // Metric Selector
          _buildMetricSelector(),

          SizedBox(height: 4.h),

          // Main Chart
          _buildMainChart(),

          SizedBox(height: 4.h),

          // Summary Cards
          _buildSummaryCards(),

          SizedBox(height: 4.h),

          // Compliance Rate Chart
          _buildComplianceRateChart(),

          SizedBox(height: 4.h),

          // Common Issues Chart
          _buildCommonIssuesChart(),

          SizedBox(height: 4.h),

          // Inspector Performance
          _buildInspectorPerformance(),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedPeriod,
          items: _periodOptions.map((option) {
            return DropdownMenuItem<String>(
              value: option['value'],
              child: Text(
                option['label']!,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedPeriod = value;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildMetricSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _metricOptions.map((option) {
          final isSelected = _selectedMetric == option['value'];
          return Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: FilterChip(
              selected: isSelected,
              label: Text(option['label']!),
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedMetric = option['value']!;
                  });
                }
              },
              selectedColor: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.2),
              checkmarkColor: AppTheme.lightTheme.colorScheme.primary,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMainChart() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getChartTitle(),
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 3.h),
            SizedBox(
              height: 40.h,
              child: LineChart(
                _buildLineChartData(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            title: 'Inspections totales',
            value: '${widget.inspectionHistory.length}',
            icon: 'assignment',
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: _buildSummaryCard(
            title: 'Taux de conformité',
            value: '${_calculateComplianceRate().toStringAsFixed(1)}%',
            icon: 'check_circle',
            color: AppTheme.successLight,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: _buildSummaryCard(
            title: 'Problèmes détectés',
            value: '${_getTotalIssues()}',
            icon: 'warning',
            color: AppTheme.warningLight,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: icon,
                  color: color,
                  size: 20,
                ),
                const Spacer(),
                Text(
                  value,
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplianceRateChart() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Répartition des statuts',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 3.h),
            SizedBox(
              height: 30.h,
              child: PieChart(
                _buildPieChartData(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommonIssuesChart() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Problèmes les plus fréquents',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 3.h),
            SizedBox(
              height: 25.h,
              child: BarChart(
                _buildBarChartData(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInspectorPerformance() {
    final inspectorStats = _calculateInspectorStats();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance des inspecteurs',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 3.h),
            ...inspectorStats.map((stat) => _buildInspectorStatTile(stat)),
          ],
        ),
      ),
    );
  }

  Widget _buildInspectorStatTile(Map<String, dynamic> stat) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              stat['name'],
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
          Expanded(
            flex: 2,
            child: LinearProgressIndicator(
              value: stat['score'] / 100,
              backgroundColor: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                _getScoreColor(stat['score']),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Text(
            '${stat['score'].toStringAsFixed(1)}%',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: _getScoreColor(stat['score']),
            ),
          ),
        ],
      ),
    );
  }

  String _getChartTitle() {
    switch (_selectedMetric) {
      case 'compliance':
        return 'Évolution de la conformité';
      case 'issues':
        return 'Nombre de problèmes détectés';
      case 'duration':
        return 'Durée moyenne des inspections';
      case 'score':
        return 'Score moyen de conformité';
      default:
        return 'Analyse des tendances';
    }
  }

  LineChartData _buildLineChartData() {
    final spots = <FlSpot>[];

    // Generate sample data points based on inspection history
    for (int i = 0; i < 7; i++) {
      double value;
      switch (_selectedMetric) {
        case 'compliance':
          value = 85 + (i * 2) + (i % 2 == 0 ? 5 : -3);
          break;
        case 'issues':
          value = 3 - (i * 0.3) + (i % 3 == 0 ? 1 : 0);
          break;
        case 'duration':
          value = 45 + (i * 1.5) - (i % 2 == 0 ? 2 : 1);
          break;
        case 'score':
          value = 88 + (i * 1.2) + (i % 2 == 0 ? 3 : -2);
          break;
        default:
          value = 50 + i * 5;
      }
      spots.add(FlSpot(i.toDouble(), value));
    }

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: _selectedMetric == 'issues' ? 1 : 10,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              const days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
              if (value.toInt() < days.length) {
                return Text(
                  days[value.toInt()],
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                );
              }
              return const Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: _selectedMetric == 'issues' ? 1 : 20,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                _selectedMetric == 'compliance' || _selectedMetric == 'score'
                    ? '${value.toInt()}%'
                    : value.toInt().toString(),
                style: AppTheme.lightTheme.textTheme.bodySmall,
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      minX: 0,
      maxX: 6,
      minY: _selectedMetric == 'issues' ? 0 : 40,
      maxY: _selectedMetric == 'issues' ? 5 : 100,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              AppTheme.lightTheme.colorScheme.primary,
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
            ],
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: AppTheme.lightTheme.colorScheme.primary,
                strokeWidth: 2,
                strokeColor: AppTheme.lightTheme.colorScheme.surface,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  PieChartData _buildPieChartData() {
    final statusCounts = <String, int>{};
    for (final inspection in widget.inspectionHistory) {
      final status = inspection['status'] as String;
      statusCounts[status] = (statusCounts[status] ?? 0) + 1;
    }

    final sections = <PieChartSectionData>[];
    final colors = {
      'passed': AppTheme.successLight,
      'warning': AppTheme.warningLight,
      'failed': AppTheme.errorLight,
    };

    statusCounts.forEach((status, count) {
      final percentage = (count / widget.inspectionHistory.length) * 100;
      sections.add(
        PieChartSectionData(
          color: colors[status] ?? AppTheme.lightTheme.colorScheme.primary,
          value: percentage,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 60,
          titleStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    });

    return PieChartData(
      sections: sections,
      centerSpaceRadius: 40,
      sectionsSpace: 2,
    );
  }

  BarChartData _buildBarChartData() {
    final issues = [
      'Pression pneus',
      'Système freinage',
      'Éclairage',
      'Moteur',
      'Fluides',
    ];

    final counts = [8, 5, 3, 4, 2]; // Mock data

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: 10,
      barTouchData: BarTouchData(enabled: false),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              if (value.toInt() < issues.length) {
                return Padding(
                  padding: EdgeInsets.only(top: 1.h),
                  child: Text(
                    issues[value.toInt()],
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return const Text('');
            },
            reservedSize: 40,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 2,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: AppTheme.lightTheme.textTheme.bodySmall,
              );
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      barGroups: List.generate(issues.length, (index) {
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: counts[index].toDouble(),
              color: AppTheme.lightTheme.colorScheme.primary,
              width: 20,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ],
        );
      }),
    );
  }

  double _calculateComplianceRate() {
    if (widget.inspectionHistory.isEmpty) return 0;

    final passedCount = widget.inspectionHistory
        .where((inspection) => inspection['status'] == 'passed')
        .length;

    return (passedCount / widget.inspectionHistory.length) * 100;
  }

  int _getTotalIssues() {
    return widget.inspectionHistory
        .map((inspection) => inspection['issuesFound'] as int)
        .fold(0, (sum, issues) => sum + issues);
  }

  List<Map<String, dynamic>> _calculateInspectorStats() {
    final inspectorStats = <String, Map<String, dynamic>>{};

    for (final inspection in widget.inspectionHistory) {
      final inspectorName = inspection['inspectorName'] as String;
      final score = inspection['complianceScore'] as double;

      if (!inspectorStats.containsKey(inspectorName)) {
        inspectorStats[inspectorName] = {
          'name': inspectorName,
          'totalScore': 0.0,
          'count': 0,
        };
      }

      inspectorStats[inspectorName]!['totalScore'] += score;
      inspectorStats[inspectorName]!['count']++;
    }

    return inspectorStats.values.map((stat) {
      final avgScore = stat['totalScore'] / stat['count'];
      return {
        'name': stat['name'],
        'score': avgScore,
      };
    }).toList()
      ..sort((a, b) => (b['score'] as double).compareTo(a['score'] as double));
  }

  Color _getScoreColor(double score) {
    if (score >= 90) return AppTheme.successLight;
    if (score >= 75) return AppTheme.warningLight;
    return AppTheme.errorLight;
  }
}
