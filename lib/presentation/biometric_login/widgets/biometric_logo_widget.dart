import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricLogoWidget extends StatelessWidget {
  const BiometricLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Medical cross logo with app name
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primary,
            borderRadius: BorderRadius.circular(4.w),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Medical cross icon
              CustomIconWidget(
                iconName: 'local_hospital',
                color: Colors.white,
                size: 8.w,
              ),
              // Small pulse indicator
              Positioned(
                top: 2.w,
                right: 2.w,
                child: Container(
                  width: 3.w,
                  height: 3.w,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 3.h),

        // App name
        Text(
          'MediMorph',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),

        SizedBox(height: 1.h),

        // Tagline
        Text(
          'Secure Health Management',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
