import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sync_bridge/features/tasks/domain/entities/sync_log_entity.dart';
import 'package:sync_bridge/shared/theme/app_dimensions.dart';
import 'package:sync_bridge/utils/extensions.dart';

class SyncLogBanner extends StatelessWidget {
  const SyncLogBanner({required this.log});

  final SyncLogEntity log;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final color = switch (log.status) {
      'syncing' => colors.primary,
      'connected' => colors.secondary,
      'error' => colors.error,
      _ => colors.textSecondary,
    };
    return ColoredBox(
      color: color.withValues(alpha: 0.10),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          children: [
            Icon(Icons.circle, size: 8.sp, color: color),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                log.message,
                style: TextStyle(
                  fontSize: AppDimensions.kFontSize12,
                  color: color,
                ),
              ),
            ),
            Text(
              '${log.timestamp.hour}:'
              '${log.timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: AppDimensions.kFontSize11,
                color: color.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
