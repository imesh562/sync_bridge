import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:injectable/injectable.dart';
import 'package:sync_bridge/flavors/flavor_config.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

@lazySingleton
final class WebhookHelper {
  final _connections = <String, _WsConnection>{};

  Stream<Map<String, dynamic>> stream([String endpoint = '']) =>
      _connections
          .putIfAbsent(endpoint, () => _WsConnection(_urlFor(endpoint)))
          .stream;

  void send(Map<String, dynamic> payload, [String endpoint = '']) =>
      _connections[endpoint]?.send(payload);

  void disconnect([String endpoint = '']) =>
      _connections.remove(endpoint)?.dispose();

  void dispose() {
    for (final conn in _connections.values) {
      conn.dispose();
    }
    _connections.clear();
  }

  String _urlFor(String endpoint) {
    final base = FlavorConfig.instance.wsUrl;
    if (endpoint.isEmpty) return base;
    final sep = endpoint.startsWith('/') ? '' : '/';
    return '$base$sep$endpoint';
  }
}

final class _WsConnection {
  _WsConnection(this._url) {
    _connect();
  }

  final String _url;

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;
  Timer? _reconnectTimer;
  bool _disposed = false;
  int _attempt = 0;

  static const _maxBackoffSeconds = 64;

  final _controller = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get stream => _controller.stream;

  Future<void> _connect() async {
    if (_disposed) return;
    _subscription?.cancel();
    _channel?.sink.close();

    _channel = WebSocketChannel.connect(Uri.parse(_url));

    try {
      await _channel!.ready;
    } catch (_) {
      _scheduleReconnect();
      return;
    }

    if (_disposed) return;

    _subscription = _channel!.stream.listen(
      (data) {
        if (data is String) {
          try {
            final decoded = jsonDecode(data) as Map<String, dynamic>;
            _controller.add(decoded);
            _attempt = 0;
          } catch (_) {}
        }
      },
      onError: (_) => _scheduleReconnect(),
      onDone: _scheduleReconnect,
      cancelOnError: false,
    );
  }

  void _scheduleReconnect() {
    if (_disposed) return;
    _reconnectTimer?.cancel();
    _attempt++;
    final delay = Duration(
      seconds: min(_maxBackoffSeconds, pow(2, _attempt - 1).toInt()),
    );
    _reconnectTimer = Timer(delay, _connect);
  }

  void send(Map<String, dynamic> payload) =>
      _channel?.sink.add(jsonEncode(payload));

  void dispose() {
    _disposed = true;
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _channel?.sink.close();
    _controller.close();
  }
}
