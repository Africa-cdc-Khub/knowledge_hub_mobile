import 'package:flutter/foundation.dart';

mixin SafeNotifier on ChangeNotifier {
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void safeNotifyListeners() {
    if (!_disposed) {
      Future.microtask(() => notifyListeners());
    }
  }
}
