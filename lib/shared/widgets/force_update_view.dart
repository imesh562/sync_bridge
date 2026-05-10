import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sync_bridge/shared/theme/app_dimensions.dart';
import 'package:sync_bridge/utils/extensions.dart';

class ForceUpdateView extends StatelessWidget {
  const ForceUpdateView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: colors.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.system_update_alt_rounded,
                size: 64.sp,
                color: colors.primary,
              ),
              SizedBox(height: 16.h),
              Text(
                'Update Required',
                style: TextStyle(
                  fontSize: AppDimensions.kFontSize22,
                  fontWeight: FontWeight.bold,
                  color: colors.onBackground,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Please update the app to continue.',
                style: TextStyle(
                  fontSize: AppDimensions.kFontSize14,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
