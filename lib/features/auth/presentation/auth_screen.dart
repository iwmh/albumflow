import 'package:albumflow/core/command/command.dart';
import 'package:albumflow/core/command/result.dart';
import 'package:albumflow/core/config/env.dart';
import 'package:albumflow/core/error/app_error.dart';
import 'package:albumflow/features/auth/presentation/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ログイン画面（View）。
class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ディープリンクのコールバックで完了する completeLogin() のエラーを監視する。
    ref.listen(authControllerProvider, (_, next) {
      if (next.hasError && !next.isLoading) {
        final error = next.error;
        final message = error is AppError
            ? error.displayMessage
            : 'ログインに失敗しました';
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      }
    });

    final loginCommand = ref
        .watch(authControllerProvider.notifier)
        .loginCommand;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.album, size: 96),
                const SizedBox(height: 24),
                Text(
                  'AlbumFlow for Spotify',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'プレイリストからアルバム・EP を抽出して\nワンタップでまとめて登録',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                if (!Env.hasSpotifyClientId)
                  const _ClientIdWarning()
                else
                  ListenableBuilder(
                    listenable: loginCommand,
                    builder: (context, _) {
                      return FilledButton.icon(
                        onPressed: loginCommand.running
                            ? null
                            : () => _login(context, loginCommand),
                        icon: loginCommand.running
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.login),
                        label: const Text('Spotify でログイン'),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ログイン Command を実行し、失敗時にエラーメッセージを表示する。
Future<void> _login(BuildContext context, Command0<void> loginCommand) async {
  await loginCommand.execute();
  if (!context.mounted) return;
  final result = loginCommand.result;
  if (result is Err<void>) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(result.error.displayMessage)));
  }
}

class _ClientIdWarning extends StatelessWidget {
  const _ClientIdWarning();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.warning_amber, size: 32),
            const SizedBox(height: 8),
            Text(
              'SPOTIFY_CLIENT_ID が未設定です。\n'
              '--dart-define=SPOTIFY_CLIENT_ID=... を指定して起動してください。',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
