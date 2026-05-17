import 'dart:async';

import 'app_base_state.dart';

abstract class AppBaseViewModel<T> {
  final StreamController<AppBaseState<T>> _stateController =
      StreamController<AppBaseState<T>>.broadcast();

  AppBaseState<T> _state = const AppInitialState();

  bool _isDisposed = false;

  Stream<AppBaseState<T>> get stateStream => _stateController.stream;

  AppBaseState<T> get state => _state;

  bool get isDisposed => _isDisposed;

  void emit(AppBaseState<T> state) {
    if (_isDisposed) return;

    _state = state;
    _stateController.add(state);
  }

  void setLoading() {
    emit(const AppLoadingState());
  }

  void setData(T data) {
    emit(AppSuccessState<T>(data));
  }

  void setEmpty([String message = 'No data found']) {
    emit(AppEmptyState<T>(message));
  }

  void setError(String message, {Object? error, StackTrace? stackTrace}) {
    emit(AppErrorState<T>(message, error: error, stackTrace: stackTrace));
  }

  Future<void> dispose() async {
    if (_isDisposed) return;

    _isDisposed = true;
    await _stateController.close();
  }
}
