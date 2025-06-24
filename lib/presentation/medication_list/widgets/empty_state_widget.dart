import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final bool isSearchActive;
  final String searchQuery;
  final String selectedFilter;

  const EmptyStateWidget({
    super.key,
    required this.isSearchActive,
    required this.searchQuery,
    required this.selectedFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIllustration(),
            SizedBox(height: 4.h),
            _buildTitle(),
            SizedBox(height: 2.h),
            _buildDescription(),
            SizedBox(height: 4.h),
            if (!isSearchActive && selectedFilter == 'All')
              _buildAddMedicationButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.w),
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: isSearchActive ? 'search_off' : 'medication',
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 60,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    String title;

    if (isSearchActive) {
      title = 'No medications found';
    } else if (selectedFilter != 'All') {
      title = 'No $selectedFilter medications';
    } else {
      title = 'No medications yet';
    }

    return Text(
      title,
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: AppTheme.lightTheme.colorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription() {
    String description;

    if (isSearchActive) {
      description =
          'Try adjusting your search terms or filters to find what you\'re looking for.';
    } else if (selectedFilter != 'All') {
      description =
          'You don\'t have any medications with "$selectedFilter" status at the moment.';
    } else {
      description =
          'Start managing your health by adding your first medication. Tap the button below to get started.';
    }

    return Text(
      description,
      style: TextStyle(
        fontSize: 14.sp,
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        height: 1.4,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildAddMedicationButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.pushNamed(context, '/add-medication');
      },
      style: AppTheme.lightTheme.elevatedButtonTheme.style?.copyWith(
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        ),
      ),
      icon: CustomIconWidget(
        iconName: 'add',
        color: AppTheme.lightTheme.colorScheme.onPrimary,
        size: 20,
      ),
      label: Text(
        'Add Your First Medication',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
