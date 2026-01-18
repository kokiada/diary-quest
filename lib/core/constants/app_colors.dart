import 'package:flutter/material.dart';

/// DiaryQuest アプリのカラーパレット
/// ダークモード基準のファンタジー風配色
class AppColors {
  AppColors._();

  // Primary Colors - ファンタジー紺
  static const Color primary = Color(0xFF1A237E);
  static const Color primaryLight = Color(0xFF534bae);
  static const Color primaryDark = Color(0xFF000051);

  // Secondary Colors - 金色（経験値・成長）
  static const Color secondary = Color(0xFFFFD700);
  static const Color secondaryLight = Color(0xFFFFFF52);
  static const Color secondaryDark = Color(0xFFC7A600);

  // Background Colors - ダークモード
  static const Color background = Color(0xFF0D1B2A);
  static const Color surface = Color(0xFF1B263B);
  static const Color surfaceLight = Color(0xFF415A77);

  // Text Colors
  static const Color textPrimary = Color(0xFFE0E1DD);
  static const Color textSecondary = Color(0xFF778DA9);
  static const Color textAccent = Color(0xFFFFD700);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE57373);
  static const Color info = Color(0xFF64B5F6);

  // Parameter Category Colors（5カテゴリ）
  static const Color tactics = Color(0xFF7C4DFF); // 思考 - 紫
  static const Color execution = Color(0xFFFF5722); // 実行 - オレンジ
  static const Color social = Color(0xFF00BCD4); // 対人 - シアン
  static const Color mastery = Color(0xFF4CAF50); // 自制 - 緑
  static const Color frontier = Color(0xFFE91E63); // 挑戦 - ピンク

  // Base Evolution Colors
  static const Color baseTent = Color(0xFF795548);
  static const Color baseHut = Color(0xFF8D6E63);
  static const Color baseHouse = Color(0xFFA1887F);
  static const Color baseMansion = Color(0xFFBCAAA4);
  static const Color baseCastle = Color(0xFFFFD700);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [background, surface],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [secondaryLight, secondary, secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
