abstract class AppBaseController {
  bool _isDisposed = false;

  bool get isDisposed => _isDisposed;

  void onInit() {}

  void onReady() {}

  void onDispose() {}

  void dispose() {
    if (_isDisposed) return;

    onDispose();
    _isDisposed = true;
  }
}
