import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SymptomsCardWidget extends StatefulWidget {
  final List<Map<String, dynamic>> symptomsData;
  final Function(Map<String, dynamic>) onUpdate;

  const SymptomsCardWidget({
    super.key,
    required this.symptomsData,
    required this.onUpdate,
  });

  @override
  State<SymptomsCardWidget> createState() => _SymptomsCardWidgetState();
}

class _SymptomsCardWidgetState extends State<SymptomsCardWidget> {
  bool _isExpanded = true;
  double _painLevel = 0.0;
  String _selectedMood = 'neutral';
  double _energyLevel = 5.0;

  final List<String> _moodOptions = [
    'terrible',
    'bad',
    'neutral',
    'good',
    'excellent'
  ];
  final List<String> _painLocations = [
    'headache',
    'back',
    'chest',
    'stomach',
    'joints',
    'other'
  ];
  String _selectedPainLocation = 'headache';

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildHeader(),
          if (_isExpanded) ...[
            Divider(height: 1),
            _buildSymptomsContent(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return ListTile(
      leading: CustomIconWidget(
        iconName: 'psychology',
        color: AppTheme.lightTheme.colorScheme.secondary,
        size: 24,
      ),
      title: Text(
        'Symptoms & Mood',
        style: AppTheme.lightTheme.textTheme.titleMedium,
      ),
      subtitle: Text(
        '${widget.symptomsData.length} entries today',
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

  Widget _buildSymptomsContent() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          _buildPainLevelSection(),
          SizedBox(height: 3.h),
          _buildMoodSection(),
          SizedBox(height: 3.h),
          _buildEnergyLevelSection(),
          SizedBox(height: 3.h),
          _buildRecentSymptoms(),
        ],
      ),
    );
  }

  Widget _buildPainLevelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'healing',
              color: _painLevel > 5
                  ? Colors.red
                  : AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Pain Level',
              style: AppTheme.lightTheme.textTheme.titleSmall,
            ),
            Spacer(),
            Text(
              '${_painLevel.toInt()}/10',
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
            trackHeight: 8.0,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 14.0),
            activeTrackColor: _painLevel > 7
                ? Colors.red
                : _painLevel > 4
                    ? Colors.orange
                    : AppTheme.lightTheme.colorScheme.primary,
          ),
          child: Slider(
            value: _painLevel,
            min: 0.0,
            max: 10.0,
            divisions: 10,
            onChanged: (value) {
              setState(() {
                _painLevel = value;
              });
            },
            onChangeEnd: (value) {
              widget.onUpdate({
                'type': 'pain_level',
                'value': value.toInt(),
                'location': _selectedPainLocation,
                'timestamp': DateTime.now(),
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('No Pain', style: AppTheme.lightTheme.textTheme.bodySmall),
            Text('Severe', style: AppTheme.lightTheme.textTheme.bodySmall),
          ],
        ),
        SizedBox(height: 2.h),
        Text(
          'Pain Location',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _painLocations.map((location) {
            final isSelected = _selectedPainLocation == location;
            return FilterChip(
              label: Text(
                location.toUpperCase(),
                style: TextStyle(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.onPrimary
                      : AppTheme.lightTheme.colorScheme.onSurface,
                  fontSize: 12.sp,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedPainLocation = location;
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

  Widget _buildMoodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'mood',
              color: _getMoodColor(_selectedMood),
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Mood',
              style: AppTheme.lightTheme.textTheme.titleSmall,
            ),
            Spacer(),
            Text(
              _selectedMood.toUpperCase(),
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _moodOptions.map((mood) {
            final isSelected = _selectedMood == mood;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedMood = mood;
                });
                widget.onUpdate({
                  'type': 'mood',
                  'value': mood,
                  'timestamp': DateTime.now(),
                });
              },
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? _getMoodColor(mood)
                      : AppTheme.lightTheme.colorScheme.surface,
                  border: Border.all(
                    color: _getMoodColor(mood),
                    width: isSelected ? 3.0 : 1.0,
                  ),
                ),
                child: Center(
                  child: Text(
                    _getMoodEmoji(mood),
                    style: TextStyle(fontSize: 20.sp),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEnergyLevelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'battery_charging_full',
              color: _getEnergyColor(_energyLevel),
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Energy Level',
              style: AppTheme.lightTheme.textTheme.titleSmall,
            ),
            Spacer(),
            Text(
              '${_energyLevel.toInt()}/10',
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
            trackHeight: 8.0,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 14.0),
            activeTrackColor: _getEnergyColor(_energyLevel),
          ),
          child: Slider(
            value: _energyLevel,
            min: 0.0,
            max: 10.0,
            divisions: 10,
            onChanged: (value) {
              setState(() {
                _energyLevel = value;
              });
            },
            onChangeEnd: (value) {
              widget.onUpdate({
                'type': 'energy',
                'value': value.toInt(),
                'timestamp': DateTime.now(),
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Exhausted', style: AppTheme.lightTheme.textTheme.bodySmall),
            Text('Energetic', style: AppTheme.lightTheme.textTheme.bodySmall),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentSymptoms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Symptoms',
          style: AppTheme.lightTheme.textTheme.titleSmall,
        ),
        SizedBox(height: 1.h),
        ...widget.symptomsData.take(3).map((symptom) {
          return Container(
            margin: EdgeInsets.only(bottom: 1.h),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.dividerColor,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: _getSymptomIcon(symptom["type"] as String),
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatSymptomType(symptom["type"] as String),
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                      Text(
                        _formatSymptomValue(symptom),
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatTime(symptom["timestamp"] as DateTime),
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'terrible':
        return Colors.red;
      case 'bad':
        return Colors.orange;
      case 'neutral':
        return Colors.grey;
      case 'good':
        return Colors.lightGreen;
      case 'excellent':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getMoodEmoji(String mood) {
    switch (mood) {
      case 'terrible':
        return '😢';
      case 'bad':
        return '😞';
      case 'neutral':
        return '😐';
      case 'good':
        return '😊';
      case 'excellent':
        return '😄';
      default:
        return '😐';
    }
  }

  Color _getEnergyColor(double energy) {
    if (energy <= 3) return Colors.red;
    if (energy <= 6) return Colors.orange;
    return Colors.green;
  }

  String _getSymptomIcon(String type) {
    switch (type) {
      case 'pain_level':
        return 'healing';
      case 'mood':
        return 'mood';
      case 'energy':
        return 'battery_charging_full';
      default:
        return 'circle';
    }
  }

  String _formatSymptomType(String type) {
    switch (type) {
      case 'pain_level':
        return 'Pain Level';
      case 'mood':
        return 'Mood';
      case 'energy':
        return 'Energy Level';
      default:
        return type;
    }
  }

  String _formatSymptomValue(Map<String, dynamic> symptom) {
    switch (symptom["type"]) {
      case 'pain_level':
        return '${symptom["value"]}/10 - ${symptom["location"] ?? "general"}';
      case 'mood':
        return symptom["value"].toString().toUpperCase();
      case 'energy':
        return '${symptom["value"]}/10';
      default:
        return symptom["value"].toString();
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
