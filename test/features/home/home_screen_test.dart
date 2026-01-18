import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:diaryquest/features/home/home_screen.dart';
import 'package:diaryquest/providers/user_provider.dart';
import 'package:riverpod/riverpod.dart';
import 'package:diaryquest/models/user.dart';

void main() {
  group('HomeScreen', () {
    late Widget widget;

    setUp(() {
      widget = const ProviderScope(
        child: MaterialApp(
          home: HomeScreen(),
        ),
      );
    });

    testWidgets('ユーザーがいない場合にログイン画面を表示する', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('ログイン'), findsOneWidget);
    });

    testWidgets('ユーザーデータがある場合にホーム画面を表示する', (WidgetTester tester) async {
      // Arrange
      final testUser = UserModel(
        id: 'test-user-id',
        name: 'テストユーザー',
        email: 'test@example.com',
        baseLevel: 1,
        totalExp: 100,
        parameterExp: {},
        unlockedSkills: [],
        unlockedJobs: [],
        selectedNavigator: NavigatorType.aniki,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProvider.overrideWithValue(
              AsyncValue.data(UserState(user: testUser)),
            ),
          ],
          child: widget,
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('テストユーザー'), findsOneWidget);
      expect(find.text('レベル 1'), findsOneWidget);
    });

    testWidgets('クエストボタンが表示される', (WidgetTester tester) async {
      // Arrange
      final testUser = UserModel(
        id: 'test-user-id',
        name: 'テストユーザー',
        email: 'test@example.com',
        baseLevel: 1,
        totalExp: 100,
        parameterExp: {},
        unlockedSkills: [],
        unlockedJobs: [],
        selectedNavigator: NavigatorType.aniki,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProvider.overrideWithValue(
              AsyncValue.data(UserState(user: testUser)),
            ),
          ],
          child: widget,
        ),
      );
      await tester.pumpAndSettle();

      // Act & Assert
      expect(find.byIcon(Icons.mic), findsOneWidget);
      expect(find.text('クエストを記録'), findsOneWidget);
    });

    testWidgets('ナビゲーター情報が表示される', (WidgetTester tester) async {
      // Arrange
      final testUser = UserModel(
        id: 'test-user-id',
        name: 'テストユーザー',
        email: 'test@example.com',
        baseLevel: 1,
        totalExp: 100,
        parameterExp: {},
        unlockedSkills: [],
        unlockedJobs: [],
        selectedNavigator: NavigatorType.aniki,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProvider.overrideWithValue(
              AsyncValue.data(UserState(user: testUser)),
            ),
          ],
          child: widget,
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('アニキ'), findsOneWidget);
    });
  });
}