import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VitalsCardWidget extends StatefulWidget {
  final List<Map<String, dynamic>> vitalsData;
  final Function(Map<String, dynamic>) onUpdate;

  const VitalsCardWidget({
    super.key,
    required this.vitalsData,
    required this.onUpdate,
  });

  @override
  State<VitalsCardWidget> createState() => _VitalsCardWidgetState();
}

class _VitalsCardWidgetState extends State<VitalsCardWidget> {
  bool _isExpanded = true;
  double _heartRate = 72.0;
  double _systolic = 120.0;
  double _diastolic = 80.0;
  double _temperature = 98.6;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildHeader(),
          if (_isExpanded) ...[
            Divider(height: 1),
            _buildVitalsContent(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return ListTile(
      leading: CustomIconWidget(
        iconName: 'favorite',
        color: AppTheme.lightTheme.colorScheme.primary,
        size: 24,
      ),
      title: Text(
        'Vital Signs',
        style: AppTheme.lightTheme.textTheme.titleMedium,
      ),
      subtitle: Text(
        '${widget.vitalsData.length} readings today',
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

  Widget _buildVitalsContent() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          _buildHeartRateSection(),
          SizedBox(height: 3.h),
          _buildBloodPressureSection(),
          SizedBox(height: 3.h),
          _buildTemperatureSection(),
          SizedBox(height: 3.h),
          _buildQuickEntryButtons(),
        ],
      ),
    );
  }

  Widget _buildHeartRateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'monitor_heart',
              color: Colors.red,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Heart Rate',
              style: AppTheme.lightTheme.textTheme.titleSmall,
            ),
            Spacer(),
            Text(
              '${_heartRate.toInt()} BPM',
              style: AppTheme.getDataTextStyle(
                  isLight: true, fontSize: 16, fontWeight: FontWeight.w600),
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
            value: _heartRate,
            min: 40.0,
            max: 200.0,
            divisions: 160,
            onChanged: (value) {
              setState(() {
                _heartRate = value;
              });
            },
            onChangeEnd: (value) {
              widget.onUpdate({
                'type': 'heart_rate',
                'value': value.toInt(),
                'timestamp': DateTime.now(),
                'source': 'manual',
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('40', style: AppTheme.lightTheme.textTheme.bodySmall),
            Text('200', style: AppTheme.lightTheme.textTheme.bodySmall),
          ],
        ),
      ],
    );
  }

  Widget _buildBloodPressureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'bloodtype',
              color: AppTheme.lightTheme.colorScheme.secondary,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Blood Pressure',
              style: AppTheme.lightTheme.textTheme.titleSmall,
            ),
            Spacer(),
            Text(
              '${_systolic.toInt()}/${_diastolic.toInt()} mmHg',
              style: AppTheme.getDataTextStyle(
                  isLight: true, fontSize: 16, fontWeight: FontWeight.w600),
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
                  Text('Systolic',
                      style: AppTheme.lightTheme.textTheme.bodySmall),
                  SizedBox(height: 1.h),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4.0,
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 10.0),
                    ),
                    child: Slider(
                      value: _systolic,
                      min: 80.0,
                      max: 200.0,
                      divisions: 120,
                      onChanged: (value) {
                        setState(() {
                          _systolic = value;
                        });
                      },
                      onChangeEnd: (value) {
                        widget.onUpdate({
                          'type': 'blood_pressure',
                          'systolic': value.toInt(),
                          'diastolic': _diastolic.toInt(),
                          'timestamp': DateTime.now(),
                          'source': 'manual',
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Diastolic',
                      style: AppTheme.lightTheme.textTheme.bodySmall),
                  SizedBox(height: 1.h),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4.0,
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 10.0),
                    ),
                    child: Slider(
                      value: _diastolic,
                      min: 40.0,
                      max: 120.0,
                      divisions: 80,
                      onChanged: (value) {
                        setState(() {
                          _diastolic = value;
                        });
                      },
                      onChangeEnd: (value) {
                        widget.onUpdate({
                          'type': 'blood_pressure',
                          'systolic': _systolic.toInt(),
                          'diastolic': value.toInt(),
                          'timestamp': DateTime.now(),
                          'source': 'manual',
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTemperatureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'thermostat',
              color: Colors.orange,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Temperature',
              style: AppTheme.lightTheme.textTheme.titleSmall,
            ),
            Spacer(),
            Text(
              '${_temperature.toStringAsFixed(1)}°F',
              style: AppTheme.getDataTextStyle(
                  isLight: true, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _temperature = (_temperature - 0.1).clamp(95.0, 110.0);
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
                  value: _temperature,
                  min: 95.0,
                  max: 110.0,
                  divisions: 150,
                  onChanged: (value) {
                    setState(() {
                      _temperature = value;
                    });
                  },
                  onChangeEnd: (value) {
                    widget.onUpdate({
                      'type': 'temperature',
                      'value': double.parse(value.toStringAsFixed(1)),
                      'timestamp': DateTime.now(),
                      'source': 'manual',
                    });
                  },
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _temperature = (_temperature + 0.1).clamp(95.0, 110.0);
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
      ],
    );
  }

  Widget _buildQuickEntryButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Entry',
          style: AppTheme.lightTheme.textTheme.titleSmall,
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: [
            _buildQuickButton('Normal HR', () {
              setState(() {
                _heartRate = 72.0;
              });
            }),
            _buildQuickButton('Normal BP', () {
              setState(() {
                _systolic = 120.0;
                _diastolic = 80.0;
              });
            }),
            _buildQuickButton('Normal Temp', () {
              setState(() {
                _temperature = 98.6;
              });
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickButton(String label, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        minimumSize: Size(0, 0),
      ),
      child: Text(
        label,
        style: AppTheme.lightTheme.textTheme.bodySmall,
      ),
    );
  }
}
