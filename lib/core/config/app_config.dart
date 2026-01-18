import 'dart:io';
import 'package:flutter/foundation.dart';

/// 環境設定
/// secretsフォルダのAPIキーを参照
class AppConfig {
  AppConfig._();

  /// 環境
  static const Environment environment = Environment.development;

  /// FirebaseプロジェクトID
  static String get firebaseProjectId {
    switch (environment) {
      case Environment.development:
        return 'diaryquest-dev';
      case Environment.staging:
        return 'diaryquest-staging';
      case Environment.production:
        return 'diaryquest-prod';
    }
  }

  /// OpenAI APIキー
  /// 環境変数またはファイルから読み込み
  static String get openAiApiKey {
    // 環境変数またはファイルから読み込み
    return _readApiKeyFromFile() ??
        const String.fromEnvironment('OPENAI_API_KEY', defaultValue: '');
  }

  /// OpenAI モデル
  static const String openAiModel = 'gpt-4o';

  /// APIキーをファイルから読み込む（開発用）
  static String? _readApiKeyFromFile() {
    if (kReleaseMode) return null; // リリースビルドでは使用しない

    try {
      final file = File('secrets/api-key.txt');
      if (file.existsSync()) {
        return file.readAsStringSync().trim();
      }
    } catch (e) {
      // ファイルがない場合は何もしない
    }
    return null;
  }

  /// APIエンドポイント
  static Uri get apiBaseUrl {
    switch (environment) {
      case Environment.development:
        return Uri.parse('http://localhost:3000');
      case Environment.staging:
        return Uri.parse('https://staging-api.diaryquest.app');
      case Environment.production:
        return Uri.parse('https://api.diaryquest.app');
    }
  }

  /// デバッグモード
  static bool get isDebugMode {
    return kDebugMode;
  }

  /// アプリ名
  static const String appName = 'ダイクエ';

  /// アプリバージョン
  static const String appVersion = '1.0.0';

  /// ログ出力レベル
  static LogLevel get logLevel {
    switch (environment) {
      case Environment.development:
        return LogLevel.verbose;
      case Environment.staging:
        return LogLevel.info;
      case Environment.production:
        return LogLevel.error;
    }
  }
}

/// 環境区分
enum Environment {
  development,
  staging,
  production,
}

/// ログレベル
enum LogLevel {
  verbose,
  debug,
  info,
  warning,
  error,
}
