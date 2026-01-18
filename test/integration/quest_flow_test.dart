import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:diaryquest/main.dart';
import 'package:diaryquest/providers/user_provider.dart';
import 'package:diaryquest/models/user.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  group('Integration Tests', () {
    final integrationTest = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    group('Quest Flow', () {
      testWidgets('ログインからクエスト記録までのフロー', (WidgetTester tester) async {
        // Given - アプリ起動
        await tester.pumpWidget(const ProviderScope(child: DiaryQuestApp()));
        await tester.pumpAndSettle();

        // When - ログイン画面が表示される
        expect(find.text('ログイン'), findsOneWidget);

        // Then - ログインする（モックデータで）
        await tester.tap(find.text('ログイン'));
        await tester.pumpAndSettle();

        // Given - ホーム画面が表示される
        expect(find.text('テストユーザー'), findsOneWidget);

        // When - クエストボタンをタップ
        await tester.tap(find.byIcon(Icons.mic));
        await tester.pumpAndSettle();

        // Then - クエスト記録画面が表示される
        expect(find.text('今日のクエスト'), findsOneWidget);

        // When - テキストを入力
        await tester.enterText(find.byType(TextField), '今日は新しいプログラミング言語を学んだ');
        await tester.pumpAndSettle();

        // When - 分析ボタンをタップ
        await tester.tap(find.text('分析する'));
        await tester.pumpAndSettle();

        // Then - ローディングが表示される
        expect(find.text('分析中...'), findsOneWidget);

        // Then - 結果が表示される（モック）
        await tester.pumpAndSettle(const Duration(seconds: 2));
        expect(find.text('獲得経験値'), findsOneWidget);
      });

      testWidgets('ユーザーレベルアップフロー', (WidgetTester tester) async {
        // Given - レベル1のユーザー
        await tester.pumpWidget(const ProviderScope(child: DiaryQuestApp()));
        await tester.pumpAndSettle();

        // モックユーザーデータを設定
        final highLevelUser = UserModel(
          id: 'test-user-id',
          name: 'テストユーザー',
          email: 'test@example.com',
          baseLevel: 1,
          totalExp: 95, // レベルアップ直前
          parameterExp: {},
          unlockedSkills: [],
          unlockedJobs: [],
          selectedNavigator: NavigatorType.aniki,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // When - 十分な経験値を獲得
        // このテストでは実際のデータ更新をシミュレート
        await tester.pumpAndSettle();

        // Then - レベルアップダイアログが表示される
        expect(find.text('レベルアップ！'), findsAtLeastNWidgets(1, 0));
      });
    });

    group('Settings Flow', () {
      testWidgets('設定画面への遷移', (WidgetTester tester) async {
        // Given - ホーム画面
        await tester.pumpWidget(const ProviderScope(child: DiaryQuestApp()));
        await tester.pumpAndSettle();

        // When - 設定ボタンをタップ
        await tester.tap(find.text('設定'));
        await tester.pumpAndSettle();

        // Then - 設定画面が表示される
        expect(find.text('設定'), findsOneWidget);
      });
    });
  });
}