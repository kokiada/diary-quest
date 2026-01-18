import 'package:flutter_test/flutter_test.dart';
import 'package:diaryquest/models/user.dart';
import 'package:diaryquest/providers/user_provider.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  group('UserNotifier', () {
    late UserNotifier notifier;
    late Container container;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(userProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    group('初期状態', () {
      test('デフォルト状態が正しい', () {
        final state = container.read(userProvider);
        expect(state.user, isNull);
        expect(state.isLoading, isFalse);
        expect(state.error, isNull);
      });
    });

    group('ユーザーデータのロード', () {
      test('初期状態でユーザーデータがnullである', () {
        final state = container.read(userProvider);
        expect(state.user, isNull);
        expect(state.isLoading, isFalse);
        expect(state.error, isNull);
      });
    });

    group('addExperience', () {
      test('経験値を追加すると状態が更新される', () async {
        // TODO: 実際のリポジトリを使わずにテストを実装
        // これは実際の実装に依存する統合テストとして実装する
      });
    });

    group('ユーティリティメソッド', () {
      test('xpProgressが正しい値を返す', () {
        // TODO: xpProgressプロパティのテストを実装
      });

      test('levelプロパティが正しいレベルを返す', () {
        // TODO: levelプロパティのテストを実装
      });

      test('goldプロパティが正しい経験値を返す', () {
        // TODO: goldプロパティのテストを実装
      });
    });
  });
}