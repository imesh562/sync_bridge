import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sync_bridge/shared/theme/app_color_scheme.dart';
import 'package:sync_bridge/shared/theme/app_dimensions.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({required this.colors});

  final AppColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              color: colors.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.checklist_rounded,
              size: 48.sp,
              color: colors.textSecondary,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'No tasks yet',
            style: TextStyle(
              fontSize: AppDimensions.kFontSize16,
              fontWeight: FontWeight.w600,
              color: colors.onBackground,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Your tasks will appear here once synced.',
            style: TextStyle(
              fontSize: AppDimensions.kFontSize12,
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
