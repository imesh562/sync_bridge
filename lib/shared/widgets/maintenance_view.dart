import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sync_bridge/shared/theme/app_dimensions.dart';
import 'package:sync_bridge/utils/extensions.dart';

class MaintenanceView extends StatelessWidget {
  const MaintenanceView({super.key});

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
                Icons.construction_rounded,
                size: 64.sp,
                color: colors.textSecondary,
              ),
              SizedBox(height: 16.h),
              Text(
                'Under Maintenance',
                style: TextStyle(
                  fontSize: AppDimensions.kFontSize22,
                  fontWeight: FontWeight.bold,
                  color: colors.onBackground,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "We'll be back shortly. Please try again later.",
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
