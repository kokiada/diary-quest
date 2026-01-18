# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

DiaryQuest (ダイクエ) is a **Flutter-based gamified journaling app** that transforms daily diary entries into RPG-style quests. Users speak their daily experiences, AI analyzes them, and the system converts experiences into experience points across 15 growth parameters.

**Language Note**: Requirements and UI strings are in Japanese, but code is in English.

## Build and Development Commands

```bash
# Install dependencies
flutter pub get

# Run the app (requires connected device/simulator)
flutter run

# Build for iOS
flutter build ios

# Run tests
flutter test

# Static analysis
flutter analyze

# Code generation (for Freezed/JSON serialization/riverpod_generator)
flutter pub run build_runner build
```

## Architecture

### Technology Stack
- **Framework**: Flutter (Dart 3.10.7+)
- **State Management**: Riverpod (flutter_riverpod v2.4.9)
- **Backend**: Firebase (Auth + Cloud Firestore)
- **AI**: OpenAI API (GPT-4o) for quest analysis and reframing
- **Voice Input**: speech_to_text package
- **UI**: Custom pixel-art retro game style (Press Start 2P, VT323 fonts)

### Project Structure
```
lib/
├── core/
│   ├── constants/        # App colors, theme, 15 growth parameters
│   ├── config/          # App configuration
│   ├── services/        # OpenAI, Speech, Auth, Follow-up services
│   └── utils/           # Encryption, anonymization utilities
├── models/              # User, QuestEntry, Job, Skill (Freezed models)
├── repositories/        # Data layer (Firestore access)
├── providers/           # Riverpod state management
├── features/            # Feature-based organization
│   ├── auth/           # Login, Navigator selection
│   ├── home/           # Home screen with player stats
│   ├── quest/          # Quest report screen
│   ├── job_skill/      # Job/Skill display
│   ├── status/         # Status/graph screen
│   ├── weekly_report/  # Weekly report
│   └── settings/       # Settings
└── widgets/            # Shared widgets
```

### Clean Architecture Pattern
- **Presentation Layer**: Features (screens, widgets) + Providers (Riverpod)
- **Domain Layer**: Models + Core constants
- **Data Layer**: Repositories (Firestore) + Services (OpenAI, Speech)

## Key Systems

### 15 Growth Parameters (MECE Framework)
Defined in `lib/core/constants/parameters.dart`:
- **5 Categories**: Tactics, Execution, Social, Mastery, Frontier
- **15 Parameters**: 3 per category (e.g., analysis, speed, empathy, resilience, riskTaking)
- Each has: icon, description, growth message, color (by category)

### Quest Analysis Flow
1. User speaks diary entry → speech_to_text transcribes
2. OpenAI Service (`lib/core/services/openai_service.dart`) analyzes:
   - `summary`: Daily report format
   - `reframedContent`: Positive reframing
   - `earnedExp`: Map of GrowthParameter → XP (0-20 each)
   - `navigatorComment`: Personality-based feedback
3. Result saved to Firestore as `QuestEntry`
4. User's parameter XP updated via `UserNotifier`

### State Management (Riverpod)
- **Providers**: Located in `lib/providers/`
- **Key Providers**:
  - `authProvider`: Firebase Auth state
  - `userProvider`: User data, XP calculation, unlock checks
  - `questAnalysisProvider`: Quest analysis state (recording, analyzing, result)
  - `todayQuestsProvider`, `weeklyQuestsProvider`: Quest lists

### Navigator System
5 companion personalities (軍師/aniki/spirit/knight/cat):
- Selected in `NavigatorSelectionScreen` (first time only)
- Stored in `UserModel.selectedNavigator`
- Affects OpenAI prompt personality parameter

## Code Generation

This project uses **Freezed** for immutable models and **json_serializable** for JSON serialization. After modifying model files:

```bash
flutter pub run build_runner build
```

Models requiring regeneration:
- `lib/models/user.dart`
- `lib/models/quest_entry.dart`
- `lib/models/job.dart`
- `lib/models/skill.dart`

## Firebase Configuration

- Firebase project initialized in `lib/main.dart`
- iOS config: `ios/GoogleService-Info.plist`
- Firestore collections:
  - `users`: User documents
  - `quests`: QuestEntry documents (subcollection by user)

## API Keys

OpenAI API key is configured via `AppConfig` (loaded from `secrets/api-key.txt` or environment variable). Never commit API keys directly.

## UI Design System

Pixel-art retro game style (light theme):
- **Fonts**: Press Start 2P (headers), VT323 (body)
- **Colors**: `#F0F9FF` background, category-specific colors for parameters
- **Borders**: Thick 2-4px borders with pixel shadows
- **Components**: Card-based layout with rounded corners

Define in `lib/core/constants/app_colors.dart` and `app_theme.dart`.

## Testing

Currently minimal test coverage. Tests are in `test/` directory using `flutter_test`.

## Common Patterns

### Adding a New Feature Screen
1. Create screen in `lib/features/[feature]/[feature]_screen.dart`
2. Add widgets in `lib/features/[feature]/widgets/`
3. Create provider in `lib/providers/[feature]_provider.dart` if state needed
4. Wire up navigation in `HomeScreen` or via `Navigator.push`

### Modifying Growth Parameters
Edit `lib/core/constants/parameters.dart` - all parameter definitions centralized here.

### Adding New Navigator Personalities
1. Add enum value to `NavigatorType` in models
2. Add personality-specific prompt logic to OpenAI service
3. Update navigator selection UI

---

## 開発ワークフロー

### Git ワークフロー戦略

このプロジェクトは**フィーチャーブランチワークフロー**を採用し、厳格なブランチ命名規則に従います。

#### ブランチ作成ルール

**常に最新の master/main ブランチからブランチを作成してください：**

```bash
# 1. master が最新であることを確認
git checkout master
git pull origin master

# 2. 適切な命名でフィーチャーブランチを作成
git checkout -b <type>/<issue-id>-<short-description>
```

#### ブランチ命名規則

```
<type>/<issue-id>-<short-description>
```

**プレフィックスの種類：**
| プレフィックス | 用途 | 例 |
|--------------|------|-----|
| `feature/` | 新機能追加 | `feature/add-user-authentication` |
| `bugfix/` | バグ修正 | `bugfix/fix-login-crash` |
| `hotfix/` | 緊急修正（本番） | `hotfix/security-patch-20250118` |
| `refactor/` | リファクタリング | `refactor/optimize-db-queries` |
| `docs/` | ドキュメント更新 | `docs/readme-update` |
| `test/` | テスト追加/修正 | `test/add-unit-tests` |
| `chore/` | その他の作業 | `chore/update-dependencies` |

**命名ルール：**
- **小文字**のみ使用
- **ハイフン**または**スラッシュ**を区切り文字として使用
- **英数字とハイフンのみ**（アンダースコアは避ける）
- **簡潔だが説明的**に（50文字以内推奨）
- **Issue番号**を含める（該当する場合）

**例：**
```bash
# 良い例
feature/user-profile-page
feature/123-add-notification-system
bugfix/456-fix-memory-leak
refactor/cleanup-auth-module

# 悪い例 - 避けるべきブランチ名
test                                    # 説明不足
fix                                     # 具体性に欠ける
FEATURE/add-user                        # 大文字使用
feature/this-branch-is-way-too-long     # 長すぎ
```

#### 開発プロセス

**1. 新規作業開始時：**
```bash
# master からフィーチャーブランチを作成
git checkout master
git pull origin master
git checkout -b feature/your-feature-name
```

**2. 開発中：**
```bash
# 明確なメッセージでアトミックなコミットを作成
git add .
git commit -m "feat: add user profile screen

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"

# コンフリクトを避けるため頻繁に master と同期
git fetch origin master
git rebase origin/master
```

**3. 完了前：**
```bash
# テストと解析を実行
flutter test
flutter analyze

# モデル変更時はコード生成を実行
flutter pub run build_runner build --delete-conflicting-outputs
```

**4. プルリクエスト作成：**
```bash
# リモートにプッシュ
git push -u origin feature/your-feature-name

# GitHub CLI またはウェブインターフェースで PR 作成
gh pr create --title "Add user profile screen" --body "## Summary..."
```

### コミットメッセージ規約

**Conventional Commits** 仕様に従ってください：

```
<type>(<scope>): <subject>

<body>

<footer>
```

**タイプ：**
- `feat`: 新機能
- `fix`: バグ修正
- `docs`: ドキュメント変更
- `style`: コードスタイル変更（フォーマット、ロジック変更なし）
- `refactor`: コードリファクタリング
- `test`: テスト追加/更新
- `chore`: 保守タスク
- `perf`: パフォーマンス改善

**例：**
```
feat(auth): Firestore からユーザープロフィール読み込みを実装

- UserRepository に getUserProfile メソッドを追加
- ログイン時にユーザーデータを読み込むよう AuthProvider を更新
- ユーザードキュメント不在時のエラーハンドリングを追加

Fixes #DATA-1

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

### コードレビューガイドライン

#### レビュー提出前のチェックリスト

**自己レビューチェックリスト：**
- [ ] プロジェクトアーキテクチャに従っている（Clean Architecture）
- [ ] ハードコードされた値がない（定数/設定を使用）
- [ ] 適切なエラーハンドリングとユーザーフレンドリーなメッセージ
- [ ] 非同期操作のローディング状態を表示
- [ ] TASK_CHECKLIST.md で追跡されていない TODO コメントがない
- [ ] モデル変更時に `build_runner` で再生成
- [ ] 新機能のテストを追加
- [ ] コード内に console.log や print 文が残っていない
- [ ] UI 文字列は日本語、コードは英語
- [ ] Flutter 解析ツールで問題なし

#### コード品質基準

**Dart/Flutter ベストプラクティス：**
- 可能な限り `const` コンストラクタを使用
- ローカル変数では `var` より `final` を優先
- async/await を適切に使用（`.then()` チェーンを避ける）
- Effective Dart ガイドラインに従う：https://dart.dev/guides/language/effective-dart
- ウィジェットは小さく focused に保つ（200行未満）
- 再利用可能なウィジェットを別ファイルに抽出
- Riverpod プロバイダーを適切に使用（いたるところで ConsumerWidget を避ける）

**状態管理（Riverpod）：**
- プロバイダーは `lib/providers/` に配置
- 非同期操作には `AsyncValue` を使用
- プロバイダーの深いネストを避ける（最大3階層）
- コールバックには `ref.read()`、リアクティブ値には `ref.watch()` を使用

**Firestore ルール：**
- 常にネットワークエラーをハンドリング
- 適切な箇所で楽観的更新を実装
- 複数ドキュメント更新にはトランザクションを使用
- 頻繁に読み取るデータはローカルキャッシュ

### テスト戦略

#### テストピラミッド

```
        E2E (5%)
       /        \
    Integration (15%)
   /                \
Unit Tests (80%)
```

#### 単体テスト

**目標：** サービスとリポジトリで80%以上のカバレッジ

**テスト対象：**
- **サービス** (`lib/core/services/`): ビジネスロジック、API呼び出し
- **リポジトリ** (`lib/repositories/`): データ変換、エラーハンドリング
- **プロバイダー** (`lib/providers/`): 状態変更、計算処理

**例：**
```dart
// test/core/services/openai_service_test.dart
void main() {
  group('OpenAIService', () {
    test('クエストを分析して結果を返す', () async {
      // 準備（Arrange）
      final service = OpenAIService(mockClient);
      final input = '今日は新しいプログラミング言語を学んだ';

      // 実行（Act）
      final result = await service.analyzeQuest(input, NavigatorType.aniki);

      // 検証（Assert）
      expect(result.summary, isNotEmpty);
      expect(result.earnedExp, isNotEmpty);
      expect(result.navigatorComment, isNotEmpty);
    });
  });
}
```

#### ウィジェットテスト

**目標：** 主要なユーザーフローと複雑なウィジェット

**テスト対象：**
- 画面ナビゲーション
- ユーザー操作（タップ、入力）
- UI の状態変化
- エラー状態の表示

**例：**
```dart
// test/features/auth/login_screen_test.dart
void main() {
  testWidgets('ログイン失敗時にエラーを表示する', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith((ref) => mockAuthProvider),
        ],
        child: MyApp(),
      ),
    );

    await tester.enterText(
      find.byKey(Key('email_field')),
      'test@example.com',
    );
    await tester.tap(find.byKey(Key('login_button')));
    await tester.pumpAndSettle();

    expect(find.text('ログインに失敗しました'), findsOneWidget);
  });
}
```

#### 統合テスト

**目標：** 重要なユーザージャーニー

**テスト対象フロー：**
1. サインアップ → ナビゲーター選択 → ホーム画面
2. クエスト記録 → 結果表示 → XP 更新確認
3. レベルアップ → 解放通知 → スキル画面に表示

### 機能開発ワークフロー

新機能を実装する際の手順：

**1. 計画フェーズ：**
- master からフィーチャーブランチを作成
- TASK_CHECKLIST.md で関連タスクを確認
- 影響を受けるファイルとプロバイダーを特定
- テストケースを計画

**2. 実装順序：**
```
Models → Repositories → Services → Providers → UI
```

**ステップバイステップ：**
1. **モデル更新**（必要な場合）：Freezed モデルフィールドを追加
2. **build_runner 実行**：`flutter pub run build_runner build`
3. **リポジトリ更新**：データアクセスメソッドを追加
4. **サービス更新**：ビジネスロジックを追加
5. **プロバイダー作成**：Riverpod プロバイダーを追加
6. **UI 構築**：画面とウィジェットを実装
7. **テスト作成**：単体テストとウィジェットテストを追加
8. **統合**：ナビゲーションを接続

**3. 検証：**
```bash
# 静的解析
flutter analyze

# テスト実行
flutter test

# ビルドチェック
flutter build ios --debug

# デバイス/シミュレーターで手動テスト
flutter run
```

### 一般的なシナリオの扱い

#### 新規プロバイダーの追加

```dart
// lib/providers/my_feature_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 状態
class MyFeatureState {
  final String data;
  final bool isLoading;

  MyFeatureState({required this.data, this.isLoading = false});
}

// ノティファイア
class MyFeatureNotifier extends StateNotifier<MyFeatureState> {
  MyFeatureNotifier() : super(MyFeatureState(data: ''));

  Future<void> loadData() async {
    state = MyFeatureState(data: state.data, isLoading: true);
    // ここにデータ取得ロジック
    state = MyFeatureState(data: 'fetched data', isLoading: false);
  }
}

// プロバイダー
final myFeatureProvider =
    StateNotifierProvider<MyFeatureNotifier, MyFeatureState>((ref) {
  return MyFeatureNotifier();
});
```

#### 既存モデルの変更

```bash
# 1. モデルファイルを更新
# lib/models/user.dart - 新しいフィールドを追加

# 2. コードを再生成
flutter pub run build_runner build --delete-conflicting-outputs

# 3. 必要に応じてリポジトリの移行ロジックを更新
# 4. 新しいフィールドを使用するよう UI を更新
# 5. 新しいフィールドのテストを記述
```

#### デバッグのコツ

```bash
# Flutter DevTools を有効化
flutter pub global activate devtools
flutter pub global run devtools

# プロバイダー値を確認
print('Provider state: ${ref.read(userProvider)}');

# Firestore データを確認
# Firebase Console または Flutter DevTools Network ビューを使用
```

### 継続的インテグレーション

**推奨 CI チェック：**
1. `flutter analyze` - 問題なし
2. `flutter test` - すべてのテストがパス
3. `flutter pub run build_runner build` - コード生成成功
4. フォーマットチェック：`dart format --set-exit-if-changed .`
5. Null安全性検証

### タスク管理

**TASK_CHECKLIST.md の使用方法：**
1. タスク開始/完了時にチェックリスト状態を更新
2. コミットメッセージでタスクIDを参照（例：「Fixes #DATA-1」）
3. チェックリストと実際の進捗を同期
4. 新しく発見したタスクを適切なフェーズに追加

**ワークフロー例：**
```bash
# タスク開始
# TASK_CHECKLIST.md を編集: - [ ] DATA-1 → - [進行中] DATA-1

# 機能を実装
git add .
git commit -m "feat(auth): Firestore からユーザープロフィール読み込みを実装

#DATA-1 の進捗

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"

# タスク完了
# TASK_CHECKLIST.md を編集: - [進行中] DATA-1 → - [x] DATA-1
```

### ベストプラクティスまとめ

✅ **すべきこと：**
- 最新の master からブランチを作成
- 説明的なブランチ名を使用
- アトミックで文書化されたコミットを作成
- コミット前にテストを実行
- まず自分でコードレビュー
- TASK_CHECKLIST.md を最新に保つ
- 新機能のテストを記述
- Clean Architecture に従う
- エラーを適切にハンドリング
- UI は日本語、コードは英語を使用

❌ **やってはいけないこと：**
- master に直接コミット
- 曖昧なブランチ名を使用（test、fix、update）
- 追跡されていない TODO コメントを残す
- テストされていないコードをコミット
- モデル変更後のコード生成をスキップ
- 値をハードコード（定数を使用）
- 解析ツールの警告を無視
- 言語を不適切に混合
- 長すぎるブランチを作成
- ドキュメントの更新を忘れる
