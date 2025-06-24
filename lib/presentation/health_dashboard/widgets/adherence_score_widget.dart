import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class AdherenceScoreWidget extends StatelessWidget {
  final int score;
  final VoidCallback? onTap;

  const AdherenceScoreWidget({
    super.key,
    required this.score,
    this.onTap,
  });

  Color _getScoreColor() {
    if (score >= 90) return AppTheme.getSuccessColor(true);
    if (score >= 70) return AppTheme.getWarningColor(true);
    return AppTheme.lightTheme.colorScheme.error;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 20.w,
        height: 20.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.lightTheme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 18.w,
              height: 18.w,
              child: CircularProgressIndicator(
                value: score / 100,
                strokeWidth: 3,
                backgroundColor: _getScoreColor().withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(_getScoreColor()),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$score%',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _getScoreColor(),
                  ),
                ),
                Text(
                  'Adherence',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
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
