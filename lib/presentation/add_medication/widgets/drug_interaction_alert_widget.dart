import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DrugInteractionAlertWidget extends StatelessWidget {
  final List<String> interactions;

  const DrugInteractionAlertWidget({
    super.key,
    required this.interactions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'warning',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 6.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Drug Interaction Warning',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ...interactions
                .map((interaction) => Padding(
                      padding: EdgeInsets.only(bottom: 1.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 1.w,
                            height: 1.w,
                            margin: EdgeInsets.only(top: 1.h),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              interaction,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                ,
            SizedBox(height: 1.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Drug Interaction Details'),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'The following interactions have been detected:',
                                  style:
                                      AppTheme.lightTheme.textTheme.bodyMedium,
                                ),
                                SizedBox(height: 2.h),
                                ...interactions
                                    .map((interaction) => Padding(
                                          padding: EdgeInsets.only(bottom: 1.h),
                                          child: Text(
                                            '• $interaction',
                                            style: AppTheme.lightTheme.textTheme
                                                .bodyMedium,
                                          ),
                                        ))
                                    ,
                                SizedBox(height: 2.h),
                                Text(
                                  'Please consult with your healthcare provider before taking this medication.',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Understood'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.lightTheme.colorScheme.error,
                      size: 4.w,
                    ),
                    label: Text(
                      'Learn More',
                      style: TextStyle(
                        color: AppTheme.lightTheme.colorScheme.error,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.error,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
