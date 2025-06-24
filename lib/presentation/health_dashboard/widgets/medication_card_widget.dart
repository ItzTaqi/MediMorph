import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MedicationCardWidget extends StatefulWidget {
  final List<Map<String, dynamic>> medications;
  final Function(int) onMedicationTaken;
  final VoidCallback? onLongPress;

  const MedicationCardWidget({
    super.key,
    required this.medications,
    required this.onMedicationTaken,
    this.onLongPress,
  });

  @override
  State<MedicationCardWidget> createState() => _MedicationCardWidgetState();
}

class _MedicationCardWidgetState extends State<MedicationCardWidget> {
  bool _isExpanded = false;

  String _getNextDoseCountdown() {
    // Mock countdown logic
    return "2h 15m";
  }

  @override
  Widget build(BuildContext context) {
    final untakenMedications =
        widget.medications.where((med) => !(med["taken"] as bool)).toList();
    final nextMedication =
        untakenMedications.isNotEmpty ? untakenMedications.first : null;

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
                        iconName: 'medication',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 24,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Today\'s Medications',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: CustomIconWidget(
                      iconName: _isExpanded ? 'expand_less' : 'expand_more',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Next dose countdown (if any untaken medication)
            if (nextMedication != null) ...[
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Next Dose',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                        Text(
                          '${nextMedication["name"]} ${nextMedication["dosage"]}',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'in ${_getNextDoseCountdown()}',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        widget.onMedicationTaken(nextMedication["id"] as int);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.primary,
                        foregroundColor:
                            AppTheme.lightTheme.colorScheme.onPrimary,
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Mark Taken',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
            ],

            // Medication list
            if (_isExpanded) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  children:
                      (widget.medications as List).map<Widget>((medication) {
                    final med = medication as Map<String, dynamic>;
                    return Container(
                      margin: EdgeInsets.only(bottom: 2.h),
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: (med["taken"] as bool)
                            ? AppTheme.getSuccessColor(true)
                                .withValues(alpha: 0.1)
                            : AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: (med["taken"] as bool)
                              ? AppTheme.getSuccessColor(true)
                                  .withValues(alpha: 0.3)
                              : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: med["taken"] as bool,
                            onChanged: (value) {
                              if (value == true) {
                                widget.onMedicationTaken(med["id"] as int);
                              }
                            },
                            activeColor: AppTheme.getSuccessColor(true),
                          ),
                          SizedBox(width: 3.w),
                          Container(
                            width: 4.w,
                            height: 4.w,
                            decoration: BoxDecoration(
                              color: Color(med["color"] as int),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  med["name"] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    decoration: (med["taken"] as bool)
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                Text(
                                  '${med["dosage"]} at ${med["time"]}',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!(med["taken"] as bool))
                            CustomIconWidget(
                              iconName: 'schedule',
                              color: AppTheme.getWarningColor(true),
                              size: 20,
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ] else ...[
              // Compact view
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.medications.where((med) => med["taken"] as bool).length}/${widget.medications.length} taken today',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Row(
                      children:
                          widget.medications.take(3).map<Widget>((medication) {
                        final med = medication;
                        return Container(
                          width: 3.w,
                          height: 3.w,
                          margin: EdgeInsets.only(left: 1.w),
                          decoration: BoxDecoration(
                            color: (med["taken"] as bool)
                                ? AppTheme.getSuccessColor(true)
                                : Color(med["color"] as int),
                            shape: BoxShape.circle,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
