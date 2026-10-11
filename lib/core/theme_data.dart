import 'package:flutter/material.dart';
import 'app_theme.dart';

/// ThemeData global untuk MaterialApp.
class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bg,
        fontFamily: 'PlusJakartaSans',
        textTheme: const TextTheme(
          displayLarge: AppTextStyles.displayLg,
          titleMedium: AppTextStyles.titleMd,
          titleSmall: AppTextStyles.titleSm,
          bodySmall: AppTextStyles.bodySm,
          labelSmall: AppTextStyles.labelSm,
        ),
        colorScheme: const ColorScheme.dark(
          primary: AppColors.purple,
          secondary: AppColors.gold,
          surface: AppColors.surface,
          error: AppColors.rose,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: InputBorder.none,
          hintStyle: AppTextStyles.hint,
        ),
      );
}
