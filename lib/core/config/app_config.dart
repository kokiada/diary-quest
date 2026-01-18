/// 環境設定
/// secretsフォルダのAPIキーを参照
class AppConfig {
  AppConfig._();

  /// OpenAI API キー
  /// 環境変数から取得すること
  /// 実行時: flutter run --dart-define=OPENAI_API_KEY=your_key_here
  static const String openAiApiKey = String.fromEnvironment(
    'OPENAI_API_KEY',
  );

  /// OpenAI モデル
  static const String openAiModel = 'gpt-4o';

  /// アプリ名
  static const String appName = 'ダイクエ';

  /// アプリバージョン
  static const String appVersion = '1.0.0';
}
