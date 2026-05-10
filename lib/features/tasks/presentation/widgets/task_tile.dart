import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sync_bridge/features/tasks/domain/entities/task_entity.dart';
import 'package:sync_bridge/shared/theme/app_color_scheme.dart';
import 'package:sync_bridge/shared/theme/app_dimensions.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.colors,
    required this.onToggle,
    required this.onConflictTap,
  });

  final TaskEntity task;
  final AppColorScheme colors;
  final ValueChanged<bool> onToggle;
  final VoidCallback onConflictTap;

  bool get _isCompleted => task.completed == 1;

  bool get _isDirty => task.isDirty == 1;

  bool get _isConflict => task.isConflict == 1;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color:
            _isConflict ? colors.error.withValues(alpha: 0.06) : colors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color:
              _isConflict
                  ? colors.error.withValues(alpha: 0.3)
                  : colors.divider,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () => onToggle(!_isCompleted),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => onToggle(!_isCompleted),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 22.w,
                    height: 22.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isCompleted ? colors.primary : Colors.transparent,
                      border: Border.all(
                        color:
                            _isCompleted
                                ? colors.primary
                                : colors.textSecondary,
                        width: 2,
                      ),
                    ),
                    child:
                        _isCompleted
                            ? Icon(
                              Icons.check_rounded,
                              size: 13.sp,
                              color: colors.onPrimary,
                            )
                            : null,
                  ),
                ),

                SizedBox(width: 12.w),

                Expanded(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: AppDimensions.kFontSize14,
                      fontWeight: FontWeight.w500,
                      color:
                          _isCompleted
                              ? colors.textSecondary
                              : colors.onSurface,
                      decoration:
                          _isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                      decorationColor: colors.textSecondary,
                      decorationThickness: 1.5,
                    ),
                    child: Text(
                      task.title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                if (_isDirty) ...[
                  SizedBox(width: 8.w),
                  Tooltip(
                    message: 'Pending sync',
                    child: Container(
                      padding: EdgeInsets.all(5.r),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Icon(
                        Icons.cloud_upload_outlined,
                        size: 14.sp,
                        color: colors.primary,
                      ),
                    ),
                  ),
                ],
                if (_isConflict) ...[
                  SizedBox(width: 4.w),
                  Tooltip(
                    message: 'Resolve conflict',
                    child: GestureDetector(
                      onTap: onConflictTap,
                      child: Container(
                        padding: EdgeInsets.all(5.r),
                        decoration: BoxDecoration(
                          color: colors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Icon(
                          Icons.warning_amber_rounded,
                          size: 14.sp,
                          color: colors.error,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
