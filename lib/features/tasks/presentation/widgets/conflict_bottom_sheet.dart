import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sync_bridge/features/tasks/domain/entities/task_entity.dart';
import 'package:sync_bridge/shared/theme/app_color_scheme.dart';
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
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: colors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.merge_type_rounded,
                  color: colors.error,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Sync Conflict',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.onBackground,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.divider),
            ),
            child: Text(
              task.title ?? '',
              style: context.textTheme.bodyMedium?.copyWith(
                color: colors.onSurface,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'This task was modified on both this device and the server. Choose which version to keep.',
            style: context.textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),
          _ConflictOption(
            icon: Icons.cloud_done_outlined,
            iconColor: colors.primary,
            label: 'Use server version',
            description: 'Discard local changes and sync from server',
            colors: colors,
            onTap: () => onResolve(true),
          ),
          const SizedBox(height: 10),
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
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.divider),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colors.textSecondary,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
