import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MedicationFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController drugNameController;
  final TextEditingController dosageController;
  final TextEditingController instructionsController;
  final TextEditingController doctorController;
  final String selectedFrequency;
  final List<String> frequencyOptions;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool showAdvancedOptions;
  final List<Map<String, dynamic>> drugDatabase;
  final Function(String) onFrequencyChanged;
  final Function(DateTime) onStartDateChanged;
  final Function(DateTime) onEndDateChanged;
  final VoidCallback onAdvancedOptionsToggle;
  final List<String> Function(String) getFilteredDrugs;
  final List<String> Function(String) getCommonDosages;

  const MedicationFormWidget({
    super.key,
    required this.formKey,
    required this.drugNameController,
    required this.dosageController,
    required this.instructionsController,
    required this.doctorController,
    required this.selectedFrequency,
    required this.frequencyOptions,
    required this.startDate,
    required this.endDate,
    required this.showAdvancedOptions,
    required this.drugDatabase,
    required this.onFrequencyChanged,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onAdvancedOptionsToggle,
    required this.getFilteredDrugs,
    required this.getCommonDosages,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medication Details',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),

            // Drug Name Field with Autocomplete
            Text(
              'Drug Name *',
              style: AppTheme.lightTheme.textTheme.labelLarge,
            ),
            SizedBox(height: 1.h),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                return getFilteredDrugs(textEditingValue.text);
              },
              onSelected: (String selection) {
                drugNameController.text = selection;
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onFieldSubmitted) {
                controller.text = drugNameController.text;
                controller.addListener(() {
                  drugNameController.text = controller.text;
                });

                return TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: 'Enter medication name',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'medication',
                        color: AppTheme.textSecondaryLight,
                        size: 5.w,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter medication name';
                    }
                    return null;
                  },
                );
              },
            ),
            SizedBox(height: 2.h),

            // Dosage Field
            Text(
              'Dosage *',
              style: AppTheme.lightTheme.textTheme.labelLarge,
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: dosageController,
                    decoration: InputDecoration(
                      hintText: 'Amount',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'straighten',
                          color: AppTheme.textSecondaryLight,
                          size: 5.w,
                        ),
                      ),
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: null,
                    decoration: InputDecoration(
                      hintText: 'Unit',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                    ),
                    items: [
                      'mg',
                      'g',
                      'ml',
                      'tablets',
                      'capsules',
                      'drops',
                      'units'
                    ]
                        .map((unit) => DropdownMenuItem(
                              value: unit,
                              child: Text(unit),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        final currentText = dosageController.text;
                        final numericPart =
                            currentText.replaceAll(RegExp(r'[^0-9.]'), '');
                        dosageController.text = '$numericPart$value';
                      }
                    },
                  ),
                ),
              ],
            ),

            // Common dosages suggestions
            if (drugNameController.text.isNotEmpty) ...[
              SizedBox(height: 1.h),
              Wrap(
                spacing: 2.w,
                children: getCommonDosages(drugNameController.text)
                    .map((dosage) => ActionChip(
                          label: Text(dosage),
                          onPressed: () {
                            dosageController.text = dosage;
                          },
                        ))
                    .toList(),
              ),
            ],

            SizedBox(height: 2.h),

            // Frequency Field
            Text(
              'Frequency *',
              style: AppTheme.lightTheme.textTheme.labelLarge,
            ),
            SizedBox(height: 1.h),
            DropdownButtonFormField<String>(
              value: selectedFrequency,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'schedule',
                    color: AppTheme.textSecondaryLight,
                    size: 5.w,
                  ),
                ),
              ),
              items: frequencyOptions
                  .map((frequency) => DropdownMenuItem(
                        value: frequency,
                        child: Text(frequency),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  onFrequencyChanged(value);
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select frequency';
                }
                return null;
              },
            ),
            SizedBox(height: 3.h),

            // Advanced Options Toggle
            InkWell(
              onTap: onAdvancedOptionsToggle,
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName:
                        showAdvancedOptions ? 'expand_less' : 'expand_more',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 6.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Advanced Options',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Advanced Options Content
            if (showAdvancedOptions) ...[
              SizedBox(height: 2.h),

              // Start Date
              Text(
                'Start Date',
                style: AppTheme.lightTheme.textTheme.labelLarge,
              ),
              SizedBox(height: 1.h),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: startDate ?? DateTime.now(),
                    firstDate: DateTime.now().subtract(Duration(days: 30)),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (date != null) {
                    onStartDateChanged(date);
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.dividerLight),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'calendar_today',
                        color: AppTheme.textSecondaryLight,
                        size: 5.w,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        startDate != null
                            ? '${startDate!.day}/${startDate!.month}/${startDate!.year}'
                            : 'Select start date',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: startDate != null
                              ? AppTheme.textPrimaryLight
                              : AppTheme.textDisabledLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2.h),

              // End Date
              Text(
                'End Date (Optional)',
                style: AppTheme.lightTheme.textTheme.labelLarge,
              ),
              SizedBox(height: 1.h),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate:
                        endDate ?? DateTime.now().add(Duration(days: 30)),
                    firstDate: startDate ?? DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (date != null) {
                    onEndDateChanged(date);
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.dividerLight),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'event',
                        color: AppTheme.textSecondaryLight,
                        size: 5.w,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        endDate != null
                            ? '${endDate!.day}/${endDate!.month}/${endDate!.year}'
                            : 'Select end date',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: endDate != null
                              ? AppTheme.textPrimaryLight
                              : AppTheme.textDisabledLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2.h),

              // Special Instructions
              Text(
                'Special Instructions',
                style: AppTheme.lightTheme.textTheme.labelLarge,
              ),
              SizedBox(height: 1.h),
              TextFormField(
                controller: instructionsController,
                decoration: InputDecoration(
                  hintText: 'Take with food, avoid alcohol, etc.',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'note',
                      color: AppTheme.textSecondaryLight,
                      size: 5.w,
                    ),
                  ),
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),
              SizedBox(height: 2.h),

              // Prescribing Doctor
              Text(
                'Prescribing Doctor',
                style: AppTheme.lightTheme.textTheme.labelLarge,
              ),
              SizedBox(height: 1.h),
              TextFormField(
                controller: doctorController,
                decoration: InputDecoration(
                  hintText: 'Dr. Smith, Cardiologist',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'person',
                      color: AppTheme.textSecondaryLight,
                      size: 5.w,
                    ),
                  ),
                ),
                textCapitalization: TextCapitalization.words,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
