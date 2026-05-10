import 'package:flutter/material.dart';
import 'package:sync_bridge/features/tasks/domain/entities/task_entity.dart';
import 'package:sync_bridge/shared/theme/app_color_scheme.dart';

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
        borderRadius: BorderRadius.circular(12),
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
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onToggle(!_isCompleted),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => onToggle(!_isCompleted),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 22,
                    height: 22,
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
                              size: 13,
                              color: colors.onPrimary,
                            )
                            : null,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: 14,
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
                  const SizedBox(width: 8),
                  Tooltip(
                    message: 'Pending sync',
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.cloud_upload_outlined,
                        size: 14,
                        color: Color(0xFFF57C00),
                      ),
                    ),
                  ),
                ],
                if (_isConflict) ...[
                  const SizedBox(width: 4),
                  Tooltip(
                    message: 'Resolve conflict',
                    child: GestureDetector(
                      onTap: onConflictTap,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: colors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.warning_amber_rounded,
                          size: 14,
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
