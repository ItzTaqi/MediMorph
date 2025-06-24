import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MedicationCardWidget extends StatelessWidget {
  final Map<String, dynamic> medication;
  final bool isSelected;
  final bool isMultiSelectMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onMarkTaken;
  final VoidCallback onSkipDose;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MedicationCardWidget({
    super.key,
    required this.medication,
    required this.isSelected,
    required this.isMultiSelectMode,
    required this.onTap,
    required this.onLongPress,
    required this.onMarkTaken,
    required this.onSkipDose,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(medication['id']),
      background: _buildSwipeBackground(isLeftSwipe: false),
      secondaryBackground: _buildSwipeBackground(isLeftSwipe: true),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onMarkTaken();
        } else {
          onDelete();
        }
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await _showDeleteConfirmation(context);
        }
        return true;
      },
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.dividerColor,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildCardHeader(),
              _buildCardContent(),
              _buildCardFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground({required bool isLeftSwipe}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.5.h),
      decoration: BoxDecoration(
        color: isLeftSwipe
            ? AppTheme.lightTheme.colorScheme.error
            : AppTheme.getSuccessColor(true),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: isLeftSwipe ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: isLeftSwipe ? 'delete' : 'check_circle',
            color: Colors.white,
            size: 28,
          ),
          SizedBox(height: 0.5.h),
          Text(
            isLeftSwipe ? 'Delete' : 'Mark Taken',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardHeader() {
    return Padding(
      padding: EdgeInsets.all(3.w),
      child: Row(
        children: [
          if (isMultiSelectMode)
            Container(
              margin: EdgeInsets.only(right: 3.w),
              child: CustomIconWidget(
                iconName:
                    isSelected ? 'check_circle' : 'radio_button_unchecked',
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ),
          Hero(
            tag: 'medication_${medication['id']}',
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.dividerColor,
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: CustomImageWidget(
                  imageUrl: medication['imageUrl'],
                  width: 12.w,
                  height: 12.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        medication['name'],
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (medication['hasInteractionWarning'] == true)
                      Container(
                        margin: EdgeInsets.only(left: 2.w),
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.getWarningColor(true)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.getWarningColor(true),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: 'warning',
                              color: AppTheme.getWarningColor(true),
                              size: 12,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              'Interaction',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.getWarningColor(true),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${medication['dosage']} • ${medication['frequency']}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          _buildStatusBadge(),
        ],
      ),
    );
  }

  Widget _buildCardContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: Column(
        children: [
          _buildAdherenceIndicator(),
          SizedBox(height: 1.h),
          _buildNextDoseInfo(),
        ],
      ),
    );
  }

  Widget _buildCardFooter() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildPillsRemaining(),
          ),
          if (!isMultiSelectMode) ...[
            _buildQuickActionButton(
              icon: 'check',
              label: 'Mark Taken',
              color: AppTheme.getSuccessColor(true),
              onPressed: onMarkTaken,
            ),
            SizedBox(width: 2.w),
            _buildQuickActionButton(
              icon: 'schedule',
              label: 'Skip',
              color: AppTheme.getWarningColor(true),
              onPressed: onSkipDose,
            ),
            SizedBox(width: 2.w),
            _buildQuickActionButton(
              icon: 'edit',
              label: 'Edit',
              color: AppTheme.lightTheme.colorScheme.primary,
              onPressed: onEdit,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color statusColor;
    String status = medication['status'];

    switch (status) {
      case 'Active':
        statusColor = AppTheme.getSuccessColor(true);
        break;
      case 'Paused':
        statusColor = AppTheme.getWarningColor(true);
        break;
      case 'Discontinued':
        statusColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
        break;
      default:
        statusColor = AppTheme.lightTheme.colorScheme.primary;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor, width: 1),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          color: statusColor,
        ),
      ),
    );
  }

  Widget _buildAdherenceIndicator() {
    final adherenceRate = medication['adherenceRate'] as int;
    final adherenceColor = adherenceRate >= 90
        ? AppTheme.getSuccessColor(true)
        : adherenceRate >= 70
            ? AppTheme.getWarningColor(true)
            : AppTheme.lightTheme.colorScheme.error;

    return Row(
      children: [
        CustomIconWidget(
          iconName: 'trending_up',
          color: adherenceColor,
          size: 16,
        ),
        SizedBox(width: 2.w),
        Text(
          'Adherence: $adherenceRate%',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: adherenceColor,
          ),
        ),
        Spacer(),
        Container(
          width: 20.w,
          height: 0.5.h,
          decoration: BoxDecoration(
            color: adherenceColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: adherenceRate / 100,
            child: Container(
              decoration: BoxDecoration(
                color: adherenceColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextDoseInfo() {
    final nextDoseTime = medication['nextDoseTime'] as DateTime;
    final now = DateTime.now();
    final difference = nextDoseTime.difference(now);

    String timeText;
    Color timeColor;

    if (difference.isNegative) {
      timeText = 'Overdue';
      timeColor = AppTheme.lightTheme.colorScheme.error;
    } else if (difference.inHours < 1) {
      timeText = 'Due in ${difference.inMinutes}m';
      timeColor = AppTheme.getWarningColor(true);
    } else {
      timeText = 'Next: ${medication['nextDose']}';
      timeColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }

    return Row(
      children: [
        CustomIconWidget(
          iconName: 'access_time',
          color: timeColor,
          size: 16,
        ),
        SizedBox(width: 2.w),
        Text(
          timeText,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: timeColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPillsRemaining() {
    final pillsRemaining = medication['pillsRemaining'] as int;
    final totalPills = medication['totalPills'] as int;
    final percentage = pillsRemaining / totalPills;

    Color pillColor;
    if (percentage > 0.3) {
      pillColor = AppTheme.getSuccessColor(true);
    } else if (percentage > 0.1) {
      pillColor = AppTheme.getWarningColor(true);
    } else {
      pillColor = AppTheme.lightTheme.colorScheme.error;
    }

    return Row(
      children: [
        CustomIconWidget(
          iconName: 'medication',
          color: pillColor,
          size: 16,
        ),
        SizedBox(width: 2.w),
        Text(
          '$pillsRemaining pills left',
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: pillColor,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onPressed();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: color,
              size: 14,
            ),
            SizedBox(width: 1.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Delete Medication'),
            content:
                Text('Are you sure you want to delete ${medication['name']}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}
