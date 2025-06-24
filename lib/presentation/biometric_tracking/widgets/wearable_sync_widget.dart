import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WearableSyncWidget extends StatelessWidget {
  final List<Map<String, dynamic>> devices;
  final bool isLoading;
  final VoidCallback onSync;

  const WearableSyncWidget({
    super.key,
    required this.devices,
    required this.isLoading,
    required this.onSync,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: 2.h),
          _buildDevicesList(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'watch',
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 20,
        ),
        SizedBox(width: 2.w),
        Text(
          'Wearable Devices',
          style: AppTheme.lightTheme.textTheme.titleSmall,
        ),
        Spacer(),
        if (isLoading)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          )
        else
          IconButton(
            onPressed: onSync,
            icon: CustomIconWidget(
              iconName: 'sync',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
      ],
    );
  }

  Widget _buildDevicesList() {
    return Column(
      children: devices.map((device) {
        return Container(
          margin: EdgeInsets.only(bottom: 1.h),
          child: _buildDeviceItem(device),
        );
      }).toList(),
    );
  }

  Widget _buildDeviceItem(Map<String, dynamic> device) {
    final isConnected = device["connected"] as bool;
    final lastSync = device["last_sync"] as DateTime;
    final battery = device["battery"] as int;
    final deviceName = device["name"] as String;
    final deviceType = device["type"] as String;

    return Row(
      children: [
        _buildDeviceIcon(deviceType, isConnected),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                deviceName,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              Row(
                children: [
                  _buildStatusChip(isConnected),
                  SizedBox(width: 2.w),
                  Text(
                    _formatLastSync(lastSync),
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
        if (isConnected) _buildBatteryIndicator(battery),
      ],
    );
  }

  Widget _buildDeviceIcon(String deviceType, bool isConnected) {
    String iconName;
    Color iconColor;

    switch (deviceType) {
      case 'apple_watch':
        iconName = 'watch';
        break;
      case 'fitbit':
        iconName = 'fitness_center';
        break;
      default:
        iconName = 'devices';
        break;
    }

    iconColor = isConnected
        ? AppTheme.lightTheme.colorScheme.primary
        : AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.4);

    return Container(
      width: 10.w,
      height: 10.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: iconColor.withValues(alpha: 0.1),
        border: Border.all(
          color: iconColor,
          width: 1,
        ),
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: iconName,
          color: iconColor,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildStatusChip(bool isConnected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: isConnected
            ? AppTheme.getSuccessColor(true).withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isConnected ? AppTheme.getSuccessColor(true) : Colors.red,
            ),
          ),
          SizedBox(width: 1.w),
          Text(
            isConnected ? 'Connected' : 'Disconnected',
            style: TextStyle(
              color: isConnected ? AppTheme.getSuccessColor(true) : Colors.red,
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatteryIndicator(int battery) {
    Color batteryColor;
    String batteryIcon;

    if (battery > 50) {
      batteryColor = AppTheme.getSuccessColor(true);
      batteryIcon = 'battery_full';
    } else if (battery > 20) {
      batteryColor = AppTheme.getWarningColor(true);
      batteryIcon = 'battery_3_bar';
    } else {
      batteryColor = Colors.red;
      batteryIcon = 'battery_1_bar';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: batteryIcon,
          color: batteryColor,
          size: 16,
        ),
        SizedBox(width: 1.w),
        Text(
          '$battery%',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: batteryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatLastSync(DateTime lastSync) {
    final now = DateTime.now();
    final difference = now.difference(lastSync);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
