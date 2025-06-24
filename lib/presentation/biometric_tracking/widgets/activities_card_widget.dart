import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActivitiesCardWidget extends StatefulWidget {
  final List<Map<String, dynamic>> activitiesData;
  final Function(Map<String, dynamic>) onUpdate;

  const ActivitiesCardWidget({
    super.key,
    required this.activitiesData,
    required this.onUpdate,
  });

  @override
  State<ActivitiesCardWidget> createState() => _ActivitiesCardWidgetState();
}

class _ActivitiesCardWidgetState extends State<ActivitiesCardWidget> {
  bool _isExpanded = true;
  double _sleepHours = 7.5;
  String _sleepQuality = 'good';
  int _exerciseMinutes = 30;
  String _exerciseType = 'walking';
  int _waterGlasses = 6;
  int _caloriesConsumed = 1800;

  final List<String> _sleepQualityOptions = [
    'poor',
    'fair',
    'good',
    'excellent'
  ];
  final List<String> _exerciseTypes = [
    'walking',
    'running',
    'cycling',
    'swimming',
    'yoga',
    'strength'
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildHeader(),
          if (_isExpanded) ...[
            Divider(height: 1),
            _buildActivitiesContent(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return ListTile(
      leading: CustomIconWidget(
        iconName: 'directions_run',
        color: AppTheme.lightTheme.colorScheme.tertiary,
        size: 24,
      ),
      title: Text(
        'Daily Activities',
        style: AppTheme.lightTheme.textTheme.titleMedium,
      ),
      subtitle: Text(
        '${widget.activitiesData.length} activities logged',
        style: AppTheme.lightTheme.textTheme.bodySmall,
      ),
      trailing: IconButton(
        onPressed: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        icon: CustomIconWidget(
          iconName: _isExpanded ? 'expand_less' : 'expand_more',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildActivitiesContent() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          _buildSleepSection(),
          SizedBox(height: 3.h),
          _buildExerciseSection(),
          SizedBox(height: 3.h),
          _buildNutritionSection(),
          SizedBox(height: 3.h),
          _buildActivitySummary(),
        ],
      ),
    );
  }

  Widget _buildSleepSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'bedtime',
              color: Colors.indigo,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Sleep',
              style: AppTheme.lightTheme.textTheme.titleSmall,
            ),
            Spacer(),
            Text(
              '${_sleepHours.toStringAsFixed(1)} hrs',
              style: AppTheme.getDataTextStyle(
                isLight: true,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 6.0,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
          ),
          child: Slider(
            value: _sleepHours,
            min: 0.0,
            max: 12.0,
            divisions: 48,
            onChanged: (value) {
              setState(() {
                _sleepHours = value;
              });
            },
            onChangeEnd: (value) {
              widget.onUpdate({
                'type': 'sleep',
                'duration': value,
                'quality': _sleepQuality,
                'timestamp': DateTime.now(),
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0h', style: AppTheme.lightTheme.textTheme.bodySmall),
            Text('12h', style: AppTheme.lightTheme.textTheme.bodySmall),
          ],
        ),
        SizedBox(height: 2.h),
        Text(
          'Sleep Quality',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _sleepQualityOptions.map((quality) {
            final isSelected = _sleepQuality == quality;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _sleepQuality = quality;
                });
                widget.onUpdate({
                  'type': 'sleep',
                  'duration': _sleepHours,
                  'quality': quality,
                  'timestamp': DateTime.now(),
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    width: 1,
                  ),
                ),
                child: Text(
                  quality.toUpperCase(),
                  style: TextStyle(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : AppTheme.lightTheme.colorScheme.primary,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildExerciseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'fitness_center',
              color: Colors.green,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Exercise',
              style: AppTheme.lightTheme.textTheme.titleSmall,
            ),
            Spacer(),
            Text(
              '$_exerciseMinutes min',
              style: AppTheme.getDataTextStyle(
                isLight: true,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _exerciseMinutes = (_exerciseMinutes - 5).clamp(0, 300);
                });
              },
              icon: CustomIconWidget(
                iconName: 'remove',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 6.0,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                ),
                child: Slider(
                  value: _exerciseMinutes.toDouble(),
                  min: 0.0,
                  max: 300.0,
                  divisions: 60,
                  onChanged: (value) {
                    setState(() {
                      _exerciseMinutes = value.toInt();
                    });
                  },
                  onChangeEnd: (value) {
                    widget.onUpdate({
                      'type': 'exercise',
                      'activity': _exerciseType,
                      'duration': value.toInt(),
                      'timestamp': DateTime.now(),
                    });
                  },
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _exerciseMinutes = (_exerciseMinutes + 5).clamp(0, 300);
                });
              },
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Text(
          'Exercise Type',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _exerciseTypes.map((type) {
            final isSelected = _exerciseType == type;
            return FilterChip(
              label: Text(
                type.toUpperCase(),
                style: TextStyle(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.onPrimary
                      : AppTheme.lightTheme.colorScheme.onSurface,
                  fontSize: 10.sp,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _exerciseType = type;
                });
              },
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              selectedColor: AppTheme.lightTheme.colorScheme.primary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNutritionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'restaurant',
              color: Colors.orange,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Nutrition',
              style: AppTheme.lightTheme.textTheme.titleSmall,
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Water Intake',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _waterGlasses = (_waterGlasses - 1).clamp(0, 20);
                          });
                        },
                        icon: CustomIconWidget(
                          iconName: 'remove',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 16,
                        ),
                      ),
                      Text(
                        '$_waterGlasses glasses',
                        style: AppTheme.getDataTextStyle(
                          isLight: true,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _waterGlasses = (_waterGlasses + 1).clamp(0, 20);
                          });
                        },
                        icon: CustomIconWidget(
                          iconName: 'add',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calories',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _caloriesConsumed =
                                (_caloriesConsumed - 100).clamp(0, 5000);
                          });
                        },
                        icon: CustomIconWidget(
                          iconName: 'remove',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 16,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '$_caloriesConsumed cal',
                          style: AppTheme.getDataTextStyle(
                            isLight: true,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _caloriesConsumed =
                                (_caloriesConsumed + 100).clamp(0, 5000);
                          });
                        },
                        icon: CustomIconWidget(
                          iconName: 'add',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActivitySummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Summary',
          style: AppTheme.lightTheme.textTheme.titleSmall,
        ),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildSummaryRow(
                  'Sleep', '${_sleepHours.toStringAsFixed(1)} hrs', 'bedtime'),
              Divider(height: 2.h),
              _buildSummaryRow(
                  'Exercise', '$_exerciseMinutes min', 'fitness_center'),
              Divider(height: 2.h),
              _buildSummaryRow(
                  'Water', '$_waterGlasses glasses', 'local_drink'),
              Divider(height: 2.h),
              _buildSummaryRow(
                  'Calories', '$_caloriesConsumed cal', 'restaurant'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String title, String value, String iconName) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 20,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ),
        Text(
          value,
          style: AppTheme.getDataTextStyle(
            isLight: true,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
