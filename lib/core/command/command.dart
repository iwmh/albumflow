import 'package:albumflow/core/command/result.dart';
import 'package:flutter/foundation.dart';

typedef CommandAction0<T> = Future<Result<T>> Function();
typedef CommandAction1<T, A> = Future<Result<T>> Function(A argument);

/// ユーザー操作（ボタン押下など）をラップし、実行中・成功・失敗の状態を
/// `ChangeNotifier` として公開する基底クラス。
///
/// View はこれを監視してボタンの無効化やエラー表示を行う。
/// （[Flutter App architecture: Recommendations](https://docs.flutter.dev/app-architecture/recommendations)
/// の Commands パターン）
abstract class Command<T> extends ChangeNotifier {
  bool _running = false;
  bool get running => _running;

  Result<T>? _result;
  Result<T>? get result => _result;

  bool get isError => _result is Err<T>;
  bool get isCompleted => _result is Ok<T>;

  Future<void> _execute(CommandAction0<T> action) async {
    if (_running) return;

    _running = true;
    _result = null;
    notifyListeners();

    try {
      _result = await action();
    } finally {
      _running = false;
      notifyListeners();
    }
  }
}

/// 引数を取らないユーザー操作（ログイン・ログアウトなど）。
class Command0<T> extends Command<T> {
  Command0(this._action);

  final CommandAction0<T> _action;

  Future<void> execute() => _execute(_action);
}

/// 引数を 1 つ取るユーザー操作（プレイリスト ID の切り替えなど）。
class Command1<T, A> extends Command<T> {
  Command1(this._action);

  final CommandAction1<T, A> _action;

  Future<void> execute(A argument) => _execute(() => _action(argument));
}
