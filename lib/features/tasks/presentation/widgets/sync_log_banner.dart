import 'package:flutter/material.dart';
import 'package:sync_bridge/features/tasks/domain/entities/sync_log_entity.dart';

class SyncLogBanner extends StatelessWidget {
  const SyncLogBanner({required this.log});

  final SyncLogEntity log;

  @override
  Widget build(BuildContext context) {
    final color = switch (log.status) {
      'syncing' => Colors.orange,
      'connected' => Colors.green,
      'error' => Colors.red,
      _ => Colors.grey,
    };
    return ColoredBox(
      color: color.withOpacity(0.10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(Icons.circle, size: 8, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                log.message,
                style: TextStyle(fontSize: 12, color: color),
              ),
            ),
            Text(
              '${log.timestamp.hour}:'
              '${log.timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 11, color: color.withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }
}
