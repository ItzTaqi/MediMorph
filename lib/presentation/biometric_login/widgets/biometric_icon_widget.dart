import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricIconWidget extends StatelessWidget {
  final bool isLoading;

  const BiometricIconWidget({
    super.key,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.w,
      height: 30.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
          ],
        ),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main biometric icon
          isLoading
              ? SizedBox(
                  width: 12.w,
                  height: 12.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                )
              : CustomIconWidget(
                  iconName: 'fingerprint',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 12.w,
                ),

          // Security indicator ring
          if (!isLoading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
              ),
            ),

          // Ready state indicator
          if (!isLoading)
            Positioned(
              bottom: 4.w,
              right: 4.w,
              child: Container(
                width: 4.w,
                height: 4.w,
                decoration: BoxDecoration(
                  color: AppTheme.getSuccessColor(true),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: CustomIconWidget(
                  iconName: 'check',
                  color: Colors.white,
                  size: 2.w,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
