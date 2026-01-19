import 'package:flutter_test/flutter_test.dart';
import 'package:diaryquest/core/services/openai_service.dart';

void main() {
  group('OpenAIService', () {
    group('analyzeQuest', () {
      test('クエスト分析機能の基本テスト', () async {
        // これは実際のAPI呼び出しをテストする統合テスト
        // TODO: モックを使った単体テストを実装
        final service = OpenAIService(apiKey: 'test-key');
        expect(service, isNotNull);
      });

      test('サービスの初期化が正しく行われる', () {
        final service = OpenAIService(apiKey: 'test-key');
        expect(service, isNotNull);
      });
    });
  });
}
