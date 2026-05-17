sealed class AppBaseState<T> {
  const AppBaseState();
}

final class AppInitialState<T> extends AppBaseState<T> {
  const AppInitialState();
}

final class AppLoadingState<T> extends AppBaseState<T> {
  const AppLoadingState();
}

final class AppSuccessState<T> extends AppBaseState<T> {
  final T data;

  const AppSuccessState(this.data);
}

final class AppEmptyState<T> extends AppBaseState<T> {
  final String message;

  const AppEmptyState([this.message = 'No data found']);
}

final class AppErrorState<T> extends AppBaseState<T> {
  final String message;
  final Object? error;
  final StackTrace? stackTrace;

  const AppErrorState(this.message, {this.error, this.stackTrace});
}
