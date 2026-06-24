import 'package:albumflow/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// アプリのテーマ定義（Material 3・ダーク）。
class AppTheme {
  const AppTheme._();

  static ThemeData get darkTheme {
    const colorScheme = ColorScheme.dark(
      primary: AppColors.spotifyGreen,
      secondary: AppColors.spotifyGreen,
      surface: AppColors.surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.spotifyBlack,
      cardTheme: const CardThemeData(color: AppColors.cardBackground),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.spotifyBlack,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.spotifyGreen,
          foregroundColor: AppColors.spotifyBlack,
          // アクセシビリティ: 最小タッチターゲット 48dp。
          minimumSize: const Size(48, 48),
        ),
      ),
    );
  }
}
