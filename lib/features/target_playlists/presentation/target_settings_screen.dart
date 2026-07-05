import 'package:albumflow/core/command/result.dart';
import 'package:albumflow/core/error/app_error.dart';
import 'package:albumflow/core/widgets/error_view.dart';
import 'package:albumflow/core/widgets/loading_view.dart';
import 'package:albumflow/features/playlists/presentation/playlists_controller.dart';
import 'package:albumflow/features/target_playlists/presentation/target_settings_controller.dart';
import 'package:albumflow/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 登録先プレイリストを設定する画面。
///
/// チェックを付けたプレイリストが、アルバムのワンタップ登録先になる。
class TargetSettingsScreen extends ConsumerWidget {
  const TargetSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlists = ref.watch(playlistsControllerProvider);
    final targets = ref.watch(targetSettingsControllerProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.targetSettingsScreenTitle)),
      body: playlists.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(playlistsControllerProvider),
        ),
        data: (items) {
          final selectedIds = targets.value ?? const <String>{};
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(l10n.targetSettingsDescription),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final playlist = items[index];
                    return CheckboxListTile(
                      value: selectedIds.contains(playlist.id),
                      title: Text(
                        playlist.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(l10n.trackCount(playlist.totalTracks)),
                      onChanged: (_) => _toggle(context, ref, playlist.id),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// 登録先の ON/OFF Command を実行し、失敗時にエラーメッセージを表示する。
Future<void> _toggle(
  BuildContext context,
  WidgetRef ref,
  String playlistId,
) async {
  final toggleCommand = ref
      .read(targetSettingsControllerProvider.notifier)
      .toggleCommand;
  await toggleCommand.execute(playlistId);
  if (!context.mounted) return;
  final result = toggleCommand.result;
  if (result is Err<void>) {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(result.error.displayMessage(l10n))),
      );
  }
}
