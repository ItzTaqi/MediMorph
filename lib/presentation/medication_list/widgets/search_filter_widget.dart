import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchFilterWidget extends StatelessWidget {
  final TextEditingController searchController;
  final String selectedFilter;
  final Function(String) onFilterChanged;
  final bool isSearchActive;

  const SearchFilterWidget({
    super.key,
    required this.searchController,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.isSearchActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          _buildSearchBar(context),
          SizedBox(height: 1.5.h),
          _buildFilterChips(context),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      height: 6.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSearchActive
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.dividerColor,
          width: isSearchActive ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: CustomIconWidget(
              iconName: 'search',
              color: isSearchActive
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search medications...',
                hintStyle: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontSize: 14.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 1.5.h),
              ),
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
          if (isSearchActive)
            GestureDetector(
              onTap: () {
                searchController.clear();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: CustomIconWidget(
                  iconName: 'clear',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
          GestureDetector(
            onTap: () => _showFilterBottomSheet(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: CustomIconWidget(
                iconName: 'tune',
                color: selectedFilter != 'All'
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    final filters = ['All', 'Active', 'Paused', 'Discontinued'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter;
          return Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: FilterChip(
              label: Text(
                filter,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.onPrimary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                onFilterChanged(filter);
              },
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              selectedColor: AppTheme.lightTheme.colorScheme.primary,
              checkmarkColor: AppTheme.lightTheme.colorScheme.onPrimary,
              side: BorderSide(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.dividerColor,
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 10.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Filter Medications',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            _buildFilterOption(context, 'All', 'Show all medications'),
            _buildFilterOption(context, 'Active', 'Currently taking'),
            _buildFilterOption(context, 'Paused', 'Temporarily stopped'),
            _buildFilterOption(context, 'Discontinued', 'No longer taking'),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(
      BuildContext context, String filter, String description) {
    final isSelected = selectedFilter == filter;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Radio<String>(
        value: filter,
        groupValue: selectedFilter,
        onChanged: (value) {
          if (value != null) {
            onFilterChanged(value);
            Navigator.pop(context);
          }
        },
        activeColor: AppTheme.lightTheme.colorScheme.primary,
      ),
      title: Text(
        filter,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppTheme.lightTheme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        description,
        style: TextStyle(
          fontSize: 12.sp,
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        ),
      ),
      onTap: () {
        onFilterChanged(filter);
        Navigator.pop(context);
      },
    );
  }
}
