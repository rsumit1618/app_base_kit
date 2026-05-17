import 'app_failure.dart';

sealed class AppResult<T> {
  const AppResult();

  bool get isSuccess => this is AppSuccess<T>;

  bool get isFailure => this is AppFailureResult<T>;

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(AppFailure failure) onFailure,
  }) {
    final current = this;

    if (current is AppSuccess<T>) {
      return onSuccess(current.data);
    }

    if (current is AppFailureResult<T>) {
      return onFailure(current.failure);
    }

    throw StateError('Unknown AppResult type');
  }
}

final class AppSuccess<T> extends AppResult<T> {
  final T data;

  const AppSuccess(this.data);
}

final class AppFailureResult<T> extends AppResult<T> {
  final AppFailure failure;

  const AppFailureResult(this.failure);
}
