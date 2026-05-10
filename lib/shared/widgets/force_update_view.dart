import 'package:flutter/material.dart';

/// Shown automatically by [BaseView] when a [ForceUpdateFailure] is received.
///
/// Replace the body with your app's real force-update UI (store deep-link,
/// release notes, etc.). This screen is intentionally non-dismissible —
/// [PopScope] blocks the back button and [BaseView] navigates here with
/// [context.go] so there is no previous route to return to.
class ForceUpdateView extends StatelessWidget {
  const ForceUpdateView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.system_update_alt_rounded, size: 64),
              SizedBox(height: 16),
              Text(
                'Update Required',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Please update the app to continue.'),
            ],
          ),
        ),
      ),
    );
  }
}
