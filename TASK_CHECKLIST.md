# DiaryQuest タスクチェックリスト

**プロジェクト進捗: 約70%完了**
**更新日時: 2026-01-18**

---

## 📋 Phase 1: クリティカル修正（必須）

### Firebase 設定
- [ ] **FIRE-1**: iOS GoogleService-Info.plist ファイル追加
  - 場所: `ios/GoogleService-Info.plist`
  - Firebase Console からダウンロードして配置
  - 参考: `lib/firebase_options.dart:29`

- [進行中] **FIRE-2**: Web Firebase設定のプレースホルダー修正
  - ファイル: `lib/firebase_options.dart:29`
  - FIXME コメントを削除して本番設定に置き換え
  - 実装メモ: FIXMEコメントを削除、Firebase Consoleの説明を追加

- [ ] **FIRE-3**: Androidサポートの有効化（将来的にAndroid対応する場合）
  - ファイル: `lib/firebase_options.dart`
  - 現在は明示的に無効化されている

### データ永続化
- [進行中] **DATA-1**: ユーザープロフィールのFirestore読み込み実装
  - ファイル: `lib/providers/auth_provider.dart:72`
  - 現状: ハードコードされたモックデータ
  - 実装内容: `users` コレクションからリアルタイムにユーザーデータを読み込み
  - 実装メモ: UserRepository経由でユーザーデータを取得、存在しない場合は新規作成

- [進行中] **DATA-2**: ナビゲーター選択のFirestore保存実装
  - ファイル: `lib/providers/auth_provider.dart:120`
  - ファイル: `lib/features/auth/navigator_selection_screen.dart:195`
  - 実装内容: 選択したナビゲーターを `users.selectedNavigator` に保存
  - 実装メモ: UserRepository.updateNavigatorメソッドを実装

- [進行中] **DATA-3**: ユーザー進捗データのリアル値計算実装
  - ファイル: `lib/providers/user_provider.dart:39-42`
  - 現状: XP進捗、クエスト数、フォーカスボーナスがハードコード
  - 実装内容:
    - クエスト履歴から実際の総XPを計算
    - 本日のクエスト数を集計
    - 連続記録日数（ストリーク）を計算
    - フォーカスボーナスを動的に算出
  - 実装メモ: xpProgress、focusBonusプロパティをリアル計算に変更、_loadUserDataで並行ロード

- [進行中] **DATA-4**: ステータス画面のリアルデータ接続
  - ファイル: `lib/features/status/status_screen.dart:114-121`
  - 現状: すべてのカテゴリ値がハードコード
  - 実装内容: UserProvider から実際のパラメータ値を取得
  - 実装メモ: ConsumerWidgetに変更、parameterExpからカテゴリ値を計算

### アセット設定
- [-] **ASSET-1**: フォント設定
  - ステータス: **スキップ** - デフォルトフォントを使用
  - ファイル: `pubspec.yaml`
  - 必要フォント:
    - Press Start 2P（ヘッダー用）
    - VT323（本文用）
  - 手順:
    1. フォントファイルを `assets/fonts/` に配置
    2. `pubspec.yaml` の `fonts` セクションで宣言
    3. `app_theme.dart` でフォントファミリーを指定

- [ ] **ASSET-2**: 画像アセット追加
  - ディレクトリ: `assets/images/bases/`, `assets/images/navigators/`
  - 内容: 軍師、アニキ、スピリット、騎士、猫のキャラクター画像

- [ ] **ASSET-3**: アニメーションアセット追加
  - ディレクトリ: `assets/animations/`
  - 内容: レベルアップ、スキル解放、ジョブ変更のアニメーション

---

## 📋 Phase 2: 機能完成（推奨）

### ナビゲーション
- [ ] **NAV-1**: 下部ナビゲーションタブの実装
  - ファイル: `lib/features/home/home_screen.dart`
  - 未実装タブ:
    - クエスト履歴タブ
    - ジョブ/スキルタブ
    - ステータスタブ
    - 設定タブ
  - 実装内容: 各タブをタップ時に対応する画面に遷移

### アニメーション
- [ ] **ANIM-1**: スキル解放アニメーション実装
  - ファイル: `lib/providers/user_provider.dart:102, 160`
  - 内容: 新スキル解放時の通知とアニメーション表示

- [ ] **ANIM-2**: ジョブ解放アニメーション実装
  - ファイル: `lib/providers/user_provider.dart:103`
  - 内容: 新ジョブ解放時の通知とアニメーション表示

- [ ] **ANIM-3**: ベース進化アニメーション実装
  - 内容: レベルに応じたプレイヤーアバターの変化

### 設定機能
- [ ] **SETT-1**: プロフィール編集機能
  - ファイル: `lib/features/settings/settings_screen.dart:83`
  - 実装内容: ユーザー名、メールアドレスの変更画面とFirestore更新

- [ ] **SETT-2**: ナビゲーター変更機能
  - ファイル: `lib/features/settings/settings_screen.dart:110`
  - 実装内容: 再度ナビゲーター選択画面へ遷移し、選択を更新

- [ ] **SETT-3**: 通知設定機能
  - ファイル: `lib/features/settings/settings_screen.dart:173`
  - 実装内容: プッシュ通知のオン/オフとFirestore保存

- [ ] **SETT-4**: 言語選択機能
  - ファイル: `lib/features/settings/settings_screen.dart:185`
  - 実装内容: 日本語/英語切り替えとローカライズ実装

---

## 📋 Phase 3: 品質向上（オプション）

### テスト
- [ ] **TEST-1**: サービス単体テスト追加
  - 対象:
    - `lib/core/services/openai_service.dart`
    - `lib/core/services/speech_service.dart`
    - `lib/core/services/auth_service.dart`

- [ ] **TEST-2**: リポジトリ単体テスト追加
  - 対象:
    - `lib/repositories/user_repository.dart`
    - `lib/repositories/quest_repository.dart`

- [ ] **TEST-3**: プロバイダー単体テスト追加
  - 対象:
    - `lib/providers/auth_provider.dart`
    - `lib/providers/user_provider.dart`
    - `lib/providers/quest_analysis_provider.dart`

- [ ] **TEST-4**: ウィジェットテスト追加
  - 対象: 各画面の主要ウィジェット
  - カバレッジ目標: 80%以上

- [ ] **TEST-5**: 統合テスト追加
  - 対象:
    - サインアップフロー
    - クエスト記録〜分析フロー
    - レベルアップフロー

### エラーハンドリング
- [ ] **ERR-1**: API通信時の包括的エラーハンドリング
  - OpenAI API エラー時のユーザーフィードバック改善
  - Firestore エラー時のリトライロジック追加

- [ ] **ERR-2**: ネットワークエラー状態の改善
  - オフライン時の適切なメッセージ表示
  - リトライUIの追加

### ドキュメント
- [ ] **DOC-1**: プロジェクト固有README作成
  - セットアップ手順
  - 環境変数設定方法
  - Firebase初期化手順

- [ ] **DOC-2**: API仕様書作成
  - OpenAI API リクエスト/レスポンス形式
  - Firestoreデータモデル仕様

- [ ] **DOC-3**: コントリビューションガイドライン作成
  - コーディング規約
  - PRフロー
  - ブランチ命名規則

### プラットフォーム拡張
- [ ] **PLAT-1**: Androidサポート有効化
  - Android用Firebase設定追加
  - Android権限設定
  - Androidビルドテスト

---

## 📊 進捗追跡

| Phase | 完了タスク | 全タスク | 完了率 |
|-------|-----------|---------|--------|
| Phase 1: クリティカル修正 | 0/13 | 0% | 🔴 未着手 |
| Phase 2: 機能完成 | 0/9 | 0% | 🔴 未着手 |
| Phase 3: 品質向上 | 0/14 | 0% | 🔴 未着手 |
| **全体** | **0/36** | **0%** | 🔴 未着手 |

---

## 🔗 関連ファイル

- プロジェクト概要: `CLAUDE.md`
- メインREADME: `README.md`
- パブリッシュ設定: `pubspec.yaml`

---

## 📝 使用方法

1. タスク開始時: `[ ]` を `[進行中]` に変更
2. タスク完了時: `[進行中]` を `[x]` に変更
3. 定期的に進捗追跡テーブルの数値を更新
4. 各タスクの実装メモを该当セクションに追記

---

**作成日: 2026-01-18**
**最終更新: 2026-01-18**
