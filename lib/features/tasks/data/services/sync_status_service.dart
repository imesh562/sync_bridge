import 'dart:async';
import 'dart:math';

import 'package:injectable/injectable.dart';
import 'package:sync_bridge/core/network/webhook_helper.dart';
import 'package:sync_bridge/features/tasks/domain/entities/sync_log_entity.dart';
import 'package:sync_bridge/utils/throttle_stream_controller.dart';

@lazySingleton
class SyncStatusService {
  SyncStatusService(this._ws);

  final WebhookHelper _ws;

  final _throttle = ThrottleStreamController<SyncLogEntity>();
  StreamSubscription<Map<String, dynamic>>? _wsSub;
  Timer? _senderTimer;
  bool _started = false;

  Stream<SyncLogEntity> watch() {
    if (!_started) {
      _started = true;
      _startSender();
      _startReceiver();
    }
    return _throttle.stream;
  }

  void _startSender() {
    _senderTimer?.cancel();
    _senderTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      _ws.send({
        'type': 'sync_log',
        'status': _pick(_statuses),
        'message': _pick(_messages),
        'timestamp': DateTime.now().toIso8601String(),
      });
    });
  }

  void _startReceiver() {
    _wsSub?.cancel();
    _wsSub = _ws.stream()
        .where((d) => d['type'] == 'sync_log')
        .listen(_handleRaw);
  }

  void _handleRaw(Map<String, dynamic> d) {
    _throttle.add(
      SyncLogEntity(
        status: d['status'] as String? ?? 'unknown',
        message: d['message'] as String? ?? '',
        timestamp:
            DateTime.tryParse(d['timestamp'] as String? ?? '') ??
            DateTime.now(),
      ),
    );
  }

  static final _rng = Random();

  static T _pick<T>(List<T> list) => list[_rng.nextInt(list.length)];

  static const _statuses = ['syncing', 'connected', 'idle'];
  static const _messages = [
    'Checking for remote updates…',
    'Pushing local changes…',
    'All tasks in sync.',
    'Fetching task list…',
    'Conflict check complete.',
  ];
}
