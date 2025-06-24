import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VitalsCardWidget extends StatefulWidget {
  final Map<String, dynamic> vitalsData;
  final VoidCallback? onLongPress;

  const VitalsCardWidget({
    super.key,
    required this.vitalsData,
    this.onLongPress,
  });

  @override
  State<VitalsCardWidget> createState() => _VitalsCardWidgetState();
}

class _VitalsCardWidgetState extends State<VitalsCardWidget> {
  int _selectedTimeframe = 0; // 0: Today, 1: Week, 2: Month
  final List<String> _timeframes = ['Today', 'Week', 'Month'];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.onLongPress,
      child: Container(
        width: double.infinity,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'favorite',
                        color: AppTheme.lightTheme.colorScheme.error,
                        size: 24,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Recent Vitals',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.vitalsData["lastUpdated"] as String,
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Current vitals grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  Expanded(
                    child: _buildVitalCard(
                      'Heart Rate',
                      '${widget.vitalsData["heartRate"]} bpm',
                      'favorite',
                      AppTheme.lightTheme.colorScheme.error,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: _buildVitalCard(
                      'Blood Pressure',
                      widget.vitalsData["bloodPressure"] as String,
                      'bloodtype',
                      AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  Expanded(
                    child: _buildVitalCard(
                      'Temperature',
                      '${widget.vitalsData["temperature"]}°F',
                      'thermostat',
                      AppTheme.getWarningColor(true),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: _buildVitalCard(
                      'O2 Saturation',
                      '${widget.vitalsData["oxygenSaturation"]}%',
                      'air',
                      AppTheme.getSuccessColor(true),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 3.h),

            // Timeframe selector
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: _timeframes.asMap().entries.map((entry) {
                  final index = entry.key;
                  final timeframe = entry.value;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTimeframe = index;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        margin: EdgeInsets.only(
                            right: index < _timeframes.length - 1 ? 2.w : 0),
                        decoration: BoxDecoration(
                          color: _selectedTimeframe == index
                              ? AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _selectedTimeframe == index
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          timeframe,
                          textAlign: TextAlign.center,
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: _selectedTimeframe == index
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            fontWeight: _selectedTimeframe == index
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 2.h),

            // Trend chart
            Container(
              height: 25.h,
              padding: EdgeInsets.all(4.w),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 10,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final trends = widget.vitalsData["trends"] as List;
                          if (value.toInt() < trends.length) {
                            final trend =
                                trends[value.toInt()] as Map<String, dynamic>;
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(
                                trend["time"] as String,
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        reservedSize: 40,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            value.toInt().toString(),
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  minX: 0,
                  maxX: ((widget.vitalsData["trends"] as List).length - 1)
                      .toDouble(),
                  minY: 60,
                  maxY: 140,
                  lineBarsData: [
                    LineChartBarData(
                      spots: (widget.vitalsData["trends"] as List)
                          .asMap()
                          .entries
                          .map((entry) {
                        final index = entry.key;
                        final trend = entry.value as Map<String, dynamic>;
                        return FlSpot(index.toDouble(),
                            (trend["systolic"] as int).toDouble());
                      }).toList(),
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.lightTheme.colorScheme.primary,
                          AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.7),
                        ],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.2),
                            AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalCard(
      String title, String value, String iconName, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
