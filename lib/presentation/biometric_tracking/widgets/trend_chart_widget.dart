import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TrendChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final String selectedMetric;
  final Function(String) onMetricChanged;

  const TrendChartWidget({
    super.key,
    required this.data,
    required this.selectedMetric,
    required this.onMetricChanged,
  });

  @override
  State<TrendChartWidget> createState() => _TrendChartWidgetState();
}

class _TrendChartWidgetState extends State<TrendChartWidget> {
  final List<String> _metrics = ['heart_rate', 'blood_pressure', 'steps'];
  final Map<String, String> _metricLabels = {
    'heart_rate': 'Heart Rate',
    'blood_pressure': 'Blood Pressure',
    'steps': 'Steps',
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 2.h),
            _buildMetricSelector(),
            SizedBox(height: 3.h),
            _buildChart(),
            SizedBox(height: 2.h),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'trending_up',
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 24,
        ),
        SizedBox(width: 2.w),
        Text(
          'Weekly Trends',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        Spacer(),
        IconButton(
          onPressed: () {
            // Show detailed analytics
          },
          icon: CustomIconWidget(
            iconName: 'fullscreen',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _metrics.map((metric) {
          final isSelected = widget.selectedMetric == metric;
          return Container(
            margin: EdgeInsets.only(right: 2.w),
            child: FilterChip(
              label: Text(
                _metricLabels[metric] ?? metric,
                style: TextStyle(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.onPrimary
                      : AppTheme.lightTheme.colorScheme.onSurface,
                  fontSize: 12.sp,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                widget.onMetricChanged(metric);
              },
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              selectedColor: AppTheme.lightTheme.colorScheme.primary,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChart() {
    return SizedBox(
      height: 30.h,
      child: Semantics(
        label: "${_metricLabels[widget.selectedMetric]} Weekly Trend Chart",
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: _getHorizontalInterval(),
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: AppTheme.lightTheme.dividerColor,
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 1,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    if (value.toInt() >= 0 &&
                        value.toInt() < widget.data.length) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text(
                          widget.data[value.toInt()]["date"] as String,
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: _getHorizontalInterval(),
                  reservedSize: 42,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        value.toInt().toString(),
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: AppTheme.lightTheme.dividerColor,
                width: 1,
              ),
            ),
            minX: 0,
            maxX: (widget.data.length - 1).toDouble(),
            minY: _getMinY(),
            maxY: _getMaxY(),
            lineBarsData: [
              LineChartBarData(
                spots: _getSpots(),
                isCurved: true,
                gradient: LinearGradient(
                  colors: [
                    AppTheme.lightTheme.colorScheme.primary,
                    AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3),
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
                      AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.3),
                      AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                  return touchedBarSpots.map((barSpot) {
                    final flSpot = barSpot;
                    return LineTooltipItem(
                      '${_metricLabels[widget.selectedMetric]}\n${flSpot.y.toStringAsFixed(0)}${_getUnit()}',
                      AppTheme.lightTheme.textTheme.bodySmall!.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    final currentValue = _getCurrentValue();
    final previousValue = _getPreviousValue();
    final change = currentValue - previousValue;
    final changePercent =
        previousValue != 0 ? (change / previousValue * 100) : 0;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLegendItem(
            'Current',
            '${currentValue.toStringAsFixed(0)}${_getUnit()}',
            AppTheme.lightTheme.colorScheme.primary,
          ),
          _buildLegendItem(
            'Previous',
            '${previousValue.toStringAsFixed(0)}${_getUnit()}',
            AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          _buildLegendItem(
            'Change',
            '${change >= 0 ? '+' : ''}${changePercent.toStringAsFixed(1)}%',
            change >= 0 ? AppTheme.getSuccessColor(true) : Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.getDataTextStyle(
            isLight: true,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ).copyWith(color: color),
        ),
      ],
    );
  }

  List<FlSpot> _getSpots() {
    return widget.data.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final value = (data[widget.selectedMetric] as num).toDouble();
      return FlSpot(index.toDouble(), value);
    }).toList();
  }

  double _getMinY() {
    final values = widget.data
        .map((d) => (d[widget.selectedMetric] as num).toDouble())
        .toList();
    final min = values.reduce((a, b) => a < b ? a : b);
    return (min * 0.9).floorToDouble();
  }

  double _getMaxY() {
    final values = widget.data
        .map((d) => (d[widget.selectedMetric] as num).toDouble())
        .toList();
    final max = values.reduce((a, b) => a > b ? a : b);
    return (max * 1.1).ceilToDouble();
  }

  double _getHorizontalInterval() {
    final range = _getMaxY() - _getMinY();
    return (range / 5).ceilToDouble();
  }

  String _getUnit() {
    switch (widget.selectedMetric) {
      case 'heart_rate':
        return ' BPM';
      case 'blood_pressure':
        return ' mmHg';
      case 'steps':
        return '';
      default:
        return '';
    }
  }

  double _getCurrentValue() {
    if (widget.data.isNotEmpty) {
      return (widget.data.last[widget.selectedMetric] as num).toDouble();
    }
    return 0.0;
  }

  double _getPreviousValue() {
    if (widget.data.length > 1) {
      return (widget.data[widget.data.length - 2][widget.selectedMetric] as num)
          .toDouble();
    }
    return _getCurrentValue();
  }
}
