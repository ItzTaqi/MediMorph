import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CameraScannerWidget extends StatelessWidget {
  final bool isScanning;
  final VoidCallback onScanPressed;

  const CameraScannerWidget({
    super.key,
    required this.isScanning,
    required this.onScanPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        height: 25.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isScanning) ...[
              SizedBox(
                width: 15.w,
                height: 15.w,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Scanning prescription...',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ] else ...[
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName: 'camera_alt',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 8.w,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Scan Prescription Bottle',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Position the prescription label within the camera frame',
                style: AppTheme.lightTheme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              ElevatedButton.icon(
                onPressed: isScanning ? null : onScanPressed,
                icon: CustomIconWidget(
                  iconName: 'qr_code_scanner',
                  color: Colors.white,
                  size: 5.w,
                ),
                label: Text('Scan Prescription'),
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
