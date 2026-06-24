import 'package:albumflow/core/error/app_error.dart';

/// Command の実行結果。成功（[Ok]）または失敗（[Err]）。
sealed class Result<T> {
  const Result();
}

/// 成功時の値を保持する。
final class Ok<T> extends Result<T> {
  const Ok(this.value);

  final T value;
}

/// 失敗時の [AppError] を保持する。
final class Err<T> extends Result<T> {
  const Err(this.error);

  final AppError error;
}
