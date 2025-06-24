import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricButtonsWidget extends StatelessWidget {
  final VoidCallback onBiometricPressed;
  final VoidCallback onPasscodePressed;
  final bool showPasscodeOption;
  final bool isLoading;
  final bool isAccountLocked;

  const BiometricButtonsWidget({
    super.key,
    required this.onBiometricPressed,
    required this.onPasscodePressed,
    required this.showPasscodeOption,
    required this.isLoading,
    required this.isAccountLocked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Primary biometric authentication button
        SizedBox(
          width: double.infinity,
          height: 7.h,
          child: ElevatedButton.icon(
            onPressed: isLoading || isAccountLocked ? null : onBiometricPressed,
            icon: isLoading
                ? SizedBox(
                    width: 5.w,
                    height: 5.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : CustomIconWidget(
                    iconName: 'fingerprint',
                    color: Colors.white,
                    size: 6.w,
                  ),
            label: Text(
              isLoading
                  ? 'Authenticating...'
                  : isAccountLocked
                      ? 'Account Locked'
                      : 'Use Face ID / Fingerprint',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isAccountLocked
                  ? AppTheme.lightTheme.colorScheme.error
                  : AppTheme.lightTheme.colorScheme.primary,
              disabledBackgroundColor: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.12),
              elevation: isLoading ? 0 : 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.w),
              ),
            ),
          ),
        ),

        // Passcode option (appears after failed biometric attempts)
        if (showPasscodeOption && !isAccountLocked) ...[
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: OutlinedButton.icon(
              onPressed: isLoading ? null : onPasscodePressed,
              icon: CustomIconWidget(
                iconName: 'lock',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              label: Text(
                'Enter Passcode',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
            ),
          ),
        ],

        // Alternative authentication methods
        if (!isAccountLocked) ...[
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  thickness: 1,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  'or',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  thickness: 1,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Alternative login options
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: isLoading
                      ? null
                      : () {
                          // Handle Face ID specifically
                          onBiometricPressed();
                        },
                  icon: CustomIconWidget(
                    iconName: 'face',
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    size: 5.w,
                  ),
                  label: Text(
                    'Face ID',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                    ),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 4.h,
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: isLoading
                      ? null
                      : () {
                          // Handle Touch ID specifically
                          onBiometricPressed();
                        },
                  icon: CustomIconWidget(
                    iconName: 'touch_app',
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    size: 5.w,
                  ),
                  label: Text(
                    'Touch ID',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
