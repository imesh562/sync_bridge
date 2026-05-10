import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sync_bridge/features/tasks/domain/entities/task_entity.dart';
import 'package:sync_bridge/shared/theme/app_color_scheme.dart';
import 'package:sync_bridge/shared/theme/app_dimensions.dart';
import 'package:sync_bridge/utils/extensions.dart';

class ConflictBottomSheet extends StatelessWidget {
  const ConflictBottomSheet({
    super.key,
    required this.task,
    required this.onResolve,
  });

  final TaskEntity task;
  final ValueChanged<bool> onResolve;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(
        24.w,
        8.h,
        24.w,
        24.h + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 20.h),
              decoration: BoxDecoration(
                color: colors.divider,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: colors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.merge_type_rounded,
                  color: colors.error,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Sync Conflict',
                style: TextStyle(
                  fontSize: AppDimensions.kFontSize16,
                  fontWeight: FontWeight.w700,
                  color: colors.onBackground,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: colors.divider),
            ),
            child: Text(
              task.title ?? '',
              style: TextStyle(
                fontSize: AppDimensions.kFontSize14,
                color: colors.onSurface,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'This task was modified on both this device and the server. Choose which version to keep.',
            style: TextStyle(
              fontSize: AppDimensions.kFontSize12,
              color: colors.textSecondary,
              height: 1.5,
            ),
          ),

          SizedBox(height: 20.h),
          _ConflictOption(
            icon: Icons.cloud_done_outlined,
            iconColor: colors.primary,
            label: 'Use server version',
            description: 'Discard local changes and sync from server',
            colors: colors,
            onTap: () => onResolve(true),
          ),
          SizedBox(height: 10.h),
          _ConflictOption(
            icon: Icons.phone_android_rounded,
            iconColor: colors.secondary,
            label: 'Keep my changes',
            description: 'Override server with your local version',
            colors: colors,
            onTap: () => onResolve(false),
          ),
        ],
      ),
    );
  }
}

class _ConflictOption extends StatelessWidget {
  const _ConflictOption({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.description,
    required this.colors,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String description;
  final AppColorScheme colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: colors.divider),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 18.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: AppDimensions.kFontSize14,
                        fontWeight: FontWeight.w600,
                        color: colors.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: AppDimensions.kFontSize12,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colors.textSecondary,
                size: 18.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
