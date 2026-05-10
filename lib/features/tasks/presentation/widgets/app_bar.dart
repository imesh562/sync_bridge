import 'package:flutter/material.dart';
import 'package:sync_bridge/shared/theme/app_color_scheme.dart';
import 'package:sync_bridge/utils/extensions.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    required this.colors,
    required this.onSync,
    required this.hasPending,
    required this.onSignOut,
  });

  final AppColorScheme colors;
  final VoidCallback onSync;
  final bool hasPending;
  final VoidCallback onSignOut;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: colors.background,
      elevation: 0,
      title: Text(
        'Tasks',
        style: context.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: colors.onBackground,
          letterSpacing: -0.3,
        ),
      ),
      actions: [
        if (hasPending) ...[
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onSync,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 4,
                children: [
                  Icon(Icons.sync_rounded, size: 18, color: colors.primary),
                  Text(
                    'Sync',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        IconButton(
          icon: Icon(Icons.logout_rounded, color: colors.onBackground),
          tooltip: 'Sign out',
          onPressed: onSignOut,
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, thickness: 1, color: colors.divider),
      ),
    );
  }
}
