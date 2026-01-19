import 'package:flutter_test/flutter_test.dart';
import 'package:diaryquest/core/services/auth_service.dart';

void main() {
  group('AuthService', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
    });

    group('基本機能', () {
      test('サービスの初期化が正しく行われる', () {
        expect(authService, isNotNull);
      });

      test('currentUserがnullを返す（未認証状態）', () {
        // TODO: 実際のFirebase Authを使ったテストを実装
        expect(authService.currentUser, isNull);
      });
    });

    group('認証機能', () {
      test('signInWithEmailAndPasswordは存在するが、実際の認証は不要', () async {
        // これは統合テストとして実装
        // TODO: モックを使ったテストを実装
      });

      test('signOutは存在するが、実際のサインアウトは不要', () async {
        // これは統合テストとして実装
        // TODO: モックを使ったテストを実装
      });
    });
  });
}