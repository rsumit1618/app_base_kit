import '../result/app_result.dart';

abstract class AppUseCase<Type, Params> {
  Future<AppResult<Type>> call(Params params);
}

final class NoParams {
  const NoParams();
}
