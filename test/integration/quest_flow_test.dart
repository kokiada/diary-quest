import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:diaryquest/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Integration Tests', () {
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

        // When - 十分な経験値を獲得
        // このテストでは実際のデータ更新をシミュレート
        await tester.pumpAndSettle();

        // Then - レベルアップダイアログが表示される
        expect(find.text('レベルアップ！'), findsWidgets);
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