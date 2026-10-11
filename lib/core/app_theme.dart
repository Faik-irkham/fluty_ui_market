import 'package:flutter/material.dart';

/// Semua warna, gradients, dan constants desain aplikasi.
class AppColors {
  AppColors._();

  static const Color bg = Color(0xFF0A0A14);
  static const Color surface = Color(0xFF111128);
  static const Color card = Color(0xFF16162E);

  static const Color gold = Color(0xFFFFD700);
  static const Color goldLight = Color(0xFFFFF0A0);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color cyan = Color(0xFF06B6D4);
  static const Color rose = Color(0xFFF43F5E);
  static const Color emerald = Color(0xFF10B981);

  static const Color textPrimary = Color(0xFFF8F8FF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF475569);

  static LinearGradient get goldGradient => const LinearGradient(
        colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get purpleGradient => const LinearGradient(
        colors: [Color(0xFF7C3AED), Color(0xFFDB2777)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}

/// TextStyles menggunakan PlusJakartaSans font lokal.
class AppTextStyles {
  AppTextStyles._();

  static const String _font = 'PlusJakartaSans';

  static const TextStyle displayLg = TextStyle(
    fontFamily: _font,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 2,
  );

  static const TextStyle titleMd = TextStyle(
    fontFamily: _font,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleSm = TextStyle(
    fontFamily: _font,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySm = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodyXs = TextStyle(
    fontFamily: _font,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle labelBold = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 1,
  );

  static const TextStyle labelSm = TextStyle(
    fontFamily: _font,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 0.8,
  );

  static const TextStyle price = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.gold,
  );

  static const TextStyle hint = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  static const TextStyle input = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle button = TextStyle(
    fontFamily: _font,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
  );
}
