import 'dart:async';

class ThrottleStreamController<T> {
  ThrottleStreamController({this.duration = const Duration(seconds: 2)});

  final Duration duration;

  final _controller = StreamController<T>.broadcast();
  Timer? _timer;
  T? _pending;
  bool _windowOpen = true;

  Stream<T> get stream => _controller.stream;

  void add(T event) {
    _pending = event;
    if (_windowOpen) {
      _windowOpen = false;
      _controller.add(event);
      _pending = null;
      _timer?.cancel();
      _timer = Timer(duration, _onWindowExpire);
    }
  }

  void _onWindowExpire() {
    _windowOpen = true;
    if (_pending != null) {
      final buffered = _pending as T;
      _pending = null;
      add(buffered);
    }
  }

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}
