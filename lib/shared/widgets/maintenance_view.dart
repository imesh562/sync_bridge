import 'package:flutter/material.dart';

/// Shown automatically by [BaseView] when a [MaintenanceFailure] is received.
///
/// Replace the body with your app's real maintenance UI (estimated time,
/// status page link, etc.). This screen is intentionally non-dismissible —
/// [PopScope] blocks the back button and [BaseView] navigates here with
/// [context.go] so there is no previous route to return to.
class MaintenanceView extends StatelessWidget {
  const MaintenanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.construction_rounded, size: 64),
              SizedBox(height: 16),
              Text(
                'Under Maintenance',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text("We'll be back shortly. Please try again later."),
            ],
          ),
        ),
      ),
    );
  }
}
