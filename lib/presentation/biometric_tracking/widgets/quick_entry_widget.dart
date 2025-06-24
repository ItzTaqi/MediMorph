import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickEntryWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const QuickEntryWidget({
    super.key,
    required this.onSave,
  });

  @override
  State<QuickEntryWidget> createState() => _QuickEntryWidgetState();
}

class _QuickEntryWidgetState extends State<QuickEntryWidget> {
  String _selectedSymptom = 'headache';
  double _severity = 5.0;
  String _notes = '';
  DateTime _timestamp = DateTime.now();

  final List<Map<String, dynamic>> _symptoms = [
    {"id": "headache", "name": "Headache", "icon": "psychology"},
    {"id": "nausea", "name": "Nausea", "icon": "sick"},
    {"id": "dizziness", "name": "Dizziness", "icon": "blur_on"},
    {"id": "fatigue", "name": "Fatigue", "icon": "battery_1_bar"},
    {"id": "chest_pain", "name": "Chest Pain", "icon": "favorite"},
    {"id": "shortness_breath", "name": "Shortness of Breath", "icon": "air"},
    {"id": "stomach_pain", "name": "Stomach Pain", "icon": "restaurant"},
    {"id": "muscle_pain", "name": "Muscle Pain", "icon": "fitness_center"},
    {"id": "joint_pain", "name": "Joint Pain", "icon": "accessibility"},
    {"id": "skin_rash", "name": "Skin Rash", "icon": "healing"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 3.h),
          _buildSymptomSelector(),
          SizedBox(height: 3.h),
          _buildSeveritySlider(),
          SizedBox(height: 3.h),
          _buildNotesField(),
          SizedBox(height: 3.h),
          _buildTimestampSelector(),
          Spacer(),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'add_circle',
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 24,
        ),
        SizedBox(width: 2.w),
        Text(
          'Quick Symptom Entry',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        Spacer(),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'close',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildSymptomSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Symptom',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 15.h,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 1.h,
              mainAxisSpacing: 2.w,
            ),
            itemCount: _symptoms.length,
            itemBuilder: (context, index) {
              final symptom = _symptoms[index];
              final isSelected = _selectedSymptom == symptom["id"];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSymptom = symptom["id"] as String;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.dividerColor,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: symptom["icon"] as String,
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                        size: 24,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        symptom["name"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSeveritySlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Severity Level',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            Spacer(),
            Text(
              '${_severity.toInt()}/10',
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
            activeTrackColor: _severity > 7
                ? Colors.red
                : _severity > 4
                    ? Colors.orange
                    : AppTheme.lightTheme.colorScheme.primary,
          ),
          child: Slider(
            value: _severity,
            min: 1.0,
            max: 10.0,
            divisions: 9,
            onChanged: (value) {
              setState(() {
                _severity = value;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Mild', style: AppTheme.lightTheme.textTheme.bodySmall),
            Text('Moderate', style: AppTheme.lightTheme.textTheme.bodySmall),
            Text('Severe', style: AppTheme.lightTheme.textTheme.bodySmall),
          ],
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Notes (Optional)',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        TextField(
          onChanged: (value) {
            setState(() {
              _notes = value;
            });
          },
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Describe any additional details about this symptom...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimestampSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'When did this occur?',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _timestamp,
                    firstDate: DateTime.now().subtract(Duration(days: 30)),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      _timestamp = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        _timestamp.hour,
                        _timestamp.minute,
                      );
                    });
                  }
                },
                icon: CustomIconWidget(
                  iconName: 'calendar_today',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
                label: Text(
                  '${_timestamp.day}/${_timestamp.month}/${_timestamp.year}',
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_timestamp),
                  );
                  if (time != null) {
                    setState(() {
                      _timestamp = DateTime(
                        _timestamp.year,
                        _timestamp.month,
                        _timestamp.day,
                        time.hour,
                        time.minute,
                      );
                    });
                  }
                },
                icon: CustomIconWidget(
                  iconName: 'access_time',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
                label: Text(
                  '${_timestamp.hour.toString().padLeft(2, '0')}:${_timestamp.minute.toString().padLeft(2, '0')}',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              final symptomData = {
                'type': 'symptom',
                'symptom': _selectedSymptom,
                'severity': _severity.toInt(),
                'notes': _notes.isNotEmpty ? _notes : null,
                'timestamp': _timestamp,
              };
              widget.onSave(symptomData);
            },
            child: Text('Save Entry'),
          ),
        ),
      ],
    );
  }
}
