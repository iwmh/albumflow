import 'package:albumflow/core/error/app_error.dart';
import 'package:albumflow/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

/// エラー表示＋再試行ボタン。
class ErrorView extends StatelessWidget {
  const ErrorView({required this.error, this.onRetry, super.key});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final message = error is AppError
        ? (error as AppError).displayMessage(l10n)
        : l10n.genericErrorMessage(error);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            if (onRetry != null) ...<Widget>[
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: onRetry,
                child: Text(l10n.retryButtonLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
