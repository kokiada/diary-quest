# DiaryQuest - データモデルと関係性

## データモデル概要

DiaryQuestは、エンティティ、関係性、ビジネスロジック間で明確な分離を実現したクリーンなデータモデルアーキテクチャを実装しています。モデルはMECE（相互に排他的で全体として網羅的）原則に従っており、スケーラビリティとパフォーマンスを念頭に設計されています。

## コアエンティティモデル

### 1. UserModel

すべてのユーザーデータと進行情報を含む中央ユーザーエンティティ。

```dart
class UserModel {
  // コアID
  final String id;                    // Firebase Auth UID
  final String email;                 // ユーザーのメールアドレス
  final String displayName;           // 表示名
  final NavigatorType selectedNavigator; // 相棒の性格

  // 進行データ
  final int totalExp;                 // 総経験値
  final int consecutiveDays;           // 現在のストリーク数
  final int baseLevel;                // ベースレベル（1-5）
  final Map<GrowthParameter, int> parameterExp; // 15パラメーター

  // コンテンツと機能
  final List<String> unlockedSkills;   // スキルID
  final List<String> unlockedJobs;   // ジョブID
  final String? currentJob;           // アクティブなジョブ

  // メタデータ
  final DateTime createdAt;          // アカウント作成日
  final DateTime lastActiveAt;        // 最終アクティビティ

  // 通知
  final bool morningBuffEnabled;      // 朝ブースト設定
  final bool eveningReportEnabled;    // 夕レポート設定
  final int morningBuffHour;          // 朝の時間（24時間表記）
  final int morningBuffMinute;
  final int eveningReportHour;       // 夕の時間（24時間表記）
  final int eveningReportMinute;
}
```

**データベーススキーマ（Firestore）**:
```json
{
  "id": "user_auth_uid",
  "email": "user@example.com",
  "displayName": "User Name",
  "selectedNavigator": "strategist",
  "totalExp": 1500,
  "consecutiveDays": 7,
  "baseLevel": 2,
  "parameterExp": {
    "analysis": 100,
    "creativity": 80,
    "expertise": 70,
    "speed": 120,
    "quality": 95,
    "systematization": 60,
    "negotiation": 40,
    "empathy": 85,
    "articulation": 75,
    "resilience": 110,
    "discipline": 90,
    "metacognition": 65,
    "riskTaking": 45,
    "unlearning": 55,
    "vision": 80
  },
  "unlockedSkills": ["skill_1", "skill_2"],
  "unlockedJobs": ["job_warrior"],
  "currentJob": "job_warrior",
  "createdAt": "2024-01-01T00:00:00Z",
  "lastActiveAt": "2024-01-20T12:00:00Z",
  "morningBuffEnabled": true,
  "eveningReportEnabled": true,
  "morningBuffHour": 7,
  "morningBuffMinute": 0,
  "eveningReportHour": 21,
  "eveningReportMinute": 0
}
```

**主なプロパティ**:
- `baseLevelName`: 日本語レベル名（テント、小屋、家、館、城）を返す
- `parameterExp`: すべての15成長パラメーターと現在の値のマップ
- `consecutiveDays`: フォーカスボーナス計算に使用

### 2. QuestEntryモデル

分析され、クエスト形式に変換された個々の日記エントリーを表します。

```dart
class QuestEntry {
  final String id;                    // FirestoreドキュメントID
  final String odId;                  // ユーザーID（所有者）
  final DateTime createdAt;          // クエスト作成タイムスタンプ
  final String rawTranscript;         // 元の音声/テキスト入力
  final String summary;               // AI生成の日次要約
  final String reframedContent;      // ポジティブなリフレーミング
  final Map<GrowthParameter, int> earnedExp; // 各パラメーター獲得XP
  final int totalEarnedExp;          // このクエストの総XP
  final String? navigatorComment;     // AI性格フィードバック
}
```

**データベーススキーマ（Firestore - サブコレクション）**:
```json
{
  "id": "auto-generated-id",
  "userId": "user_auth_uid",
  "createdAt": "2024-01-20T12:30:45Z",
  "rawTranscript": "今日は新しいプログラミング言語を学び始めた...",
  "summary": "新しい技術を学習し、基礎的な文法を理解できた",
  "reframedContent": "新しいスキルを習得する挑戦に成功し、成長の機会を掴んだ",
  "earnedExp": {
    "analysis": 15,
    "expertise": 12,
    "speed": 8,
    "quality": 10
  },
  "totalEarnedExp": 45,
  "navigatorComment": "素晴らしい！分析能力の向上が見られます"
}
```

**計算プロパティ**:
- `formattedDate`: 表示用YYYY/MM/DD形式
- `expByCategory`: カテゴリー別にグループ化されたXP（Tactics、Executionなど）

## 列挙型

### 1. NavigatorType

AIフィードバックを提供する5つの相棒性格を定義します。

```dart
enum NavigatorType {
  strategist,   // 軍師 - 分析的、データ駆動型
  bigBrother,   // アニキ - 情熱的、励まし上手
  spirit,       // 精霊 - 優しい、癒し系
  knight,       // 騎士 - 誠実、原則重視
  catFairy      // 猫妖精 - 遊び心、ユーモラス
}
```

### 2. GrowthParameter

5カテゴリーに組織された15の成長パラメーター。

```dart
enum GrowthParameter {
  // 思考カテゴリー
  analysis,      // 分析・構造化
  creativity,    // 企画・発想
  expertise,     // 専門知識

  // 実行カテゴリー
  speed,         // スピード
  quality,       // 精度・品質
  systematization, // 仕組み化

  // 対人カテゴリー
  negotiation,   // 交渉・調整
  empathy,       // 共感・サポート
  articulation,   // 言語化

  // 自制カテゴリー
  resilience,    // レジリエンス
  discipline,    // 規律・習慣
  metacognition, // メタ認知

  // 挑戦カテゴリー
  riskTaking,    // リスクテイク
  unlearning,    // 学習棄却
  vision        // ビジョン設計
}
```

### 3. ParameterCategory

関連するパラメーターをグループ化する上位レベルカテゴリー。

```dart
enum ParameterCategory {
  tactics,    // 思考 - 思考と戦略
  execution,  // 実行 - 実行と実装
  social,     // 対人 - 対人とコミュニケーション
  mastery,    // 自制 - 自己制御とマスタリー
  frontier    // 挑戦 - チャレンジと成長
}
```

## データ関係性

### 1. ユーザー - クエスト関係

```
User (1) -----> (N) Quest
  |                  |
  |                  |
  |                  |
  v                  v
Navigator      Navigator
Personality    Feedback
```

- **一対多**: 1人のユーザーは多くのクエストを持つことができる
- **参照**: クエストエントリーはユーザーID（`odId`）を参照
- **時間的**: クエストはタイムスタンプ付きで、日付でフィルタリング可能

### 2. パラメーター関係

```
ParameterCategory (5) -----> (3) GrowthParameter
        |                        |
        |                        |
        |                        |
        v                        v
  CategoryInfo              ParameterInfo
    (プロパティ)            (プロパティ)
      - カラー                - アイコン
      - 説明                  - 成長メッセージ
      - アイコン                - カテゴリー参照
```

### 3. 経験値フロー

```
ユーザー入力（音声/テキスト）
       |
       v
音声認識サービス
       |
       v
生テキスト
       |
       v
OpenAI分析
       |
       v
QuestEntry（earnedExp付き）
       |
       v
ユーザー更新
       |
       v
┌─────────────────┬─────────────────┬─────────────────┐
│ パラメーターEXP   │ 総EXP           │ レベル進行      │
│ （15パラメーター）│ （累積）         │ （ベースレベル）  │
└─────────────────┴─────────────────┴─────────────────┘
```

## データアクセスパターン

### 1. UserRepositoryメソッド

```dart
// ユーザーCRUD操作
Future<UserModel?> getUser(String odId)              // 単一ユーザー読み取り
Future<void> createUser(UserModel user)              // 新規ユーザー作成
Future<void> updateUser(UserModel user)              // ユーザーデータ更新

// 部分更新
Future<void> updateNavigator(String odId, NavigatorType navigator)
Future<void> addExperience(String odId, Map<String, int> expMap, int totalExp)
Future<void> updateConsecutiveDays(String odId, int days)

// リアルタイム更新
Stream<UserModel?> watchUser(String odId)             // 変更をリッスン
```

### 2. QuestRepositoryメソッド

```dart
// クエストCRUD操作
Future<String> saveQuest(String odId, QuestEntry quest)      // クエスト作成
Future<QuestEntry?> getQuest(String odId, String questId)    // 単一クエスト読み取り

// 一括操作
Future<List<QuestEntry>> getTodayQuests(String odId)        // 本日のクエスト
Future<List<QuestEntry>> getWeeklyQuests(String odId)       // 過去7日間
Future<List<QuestEntry>> getQuests(String odId, {int limit, DocumentSnapshot? lastDoc})

// 分析
Future<int> getQuestCount(String odId)                       // 総クエスト数

// リアルタイム更新
Stream<List<QuestEntry>> watchQuests(String odId)             // 変更をリッスン
```

## データ変換

### 1. Firestore ↔ モデル変換

すべてのモデルは双方向変換のために`fromFirestore`および`toFirestore`メソッドを実装しています：

```dart
// UserModel.fromFirestoreの例
factory UserModel.fromFirestore(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;
  return UserModel(
    id: doc.id,
    email: data['email'] ?? '',
    displayName: data['displayName'] ?? '',
    selectedNavigator: NavigatorType.values.firstWhere(
      (e) => e.name == data['selectedNavigator'],
      orElse: () => NavigatorType.strategist,
    ),
    // ... 他のフィールド
  );
}

// UserModel.toFirestoreの例
Map<String, dynamic> toFirestore() {
  return {
    'email': email,
    'displayName': displayName,
    'selectedNavigator': selectedNavigator.name,
    'parameterExp': {
      for (var entry in parameterExp.entries)
        entry.key.name: entry.value,
    },
    // ... 他のフィールド
  };
}
```

### 2. JSONシリアライゼーション

モデルはAPI通信のためのJSONシリアライゼーションをサポートしています：

```dart
// QuestAnalysisResultをJSONから
factory QuestAnalysisResult.fromJson(Map<String, dynamic> json) {
  final expMap = <GrowthParameter, int>{};
  final earnedExpJson = json['earnedExp'] as Map<String, dynamic>? ?? {};

  for (var param in GrowthParameter.values) {
    final value = earnedExpJson[param.name];
    if (value != null && value > 0) {
      expMap[param] = value as int;
    }
  }

  return QuestAnalysisResult(
    summary: json['summary'] ?? '',
    reframedContent: json['reframedContent'] ?? '',
    earnedExp: expMap,
    navigatorComment: json['navigatorComment'] ?? '',
  );
}
```

## データ検証ルール

### 1. 経験値制約
- 個別パラメーターXP：クエストあたり0-20
- クエスト総XP：すべてのパラメーターXPの合計
- ネガティブXP値なし
- XPは最大しきい値を超えられない

### 2. ユーザーデータ制約
- `consecutiveDays`は負の値でない
- `baseLevel`は1-5（包含）
- `parameterExp`はすべての15パラメーターを含む必要がある
- `totalExp`はすべてのパラメーターXPの合計と等しい

### 3. クエストデータ制約
- `createdAt`は未来の日付でない
- `rawTranscript`は500文字を超えない
- `earnedExp`は有効なパラメーター名のみを含む
- `totalEarnedExp`はearnedExp値の合計と等しい

## データ整合性パターン

### 1. アトミック更新

経験値更新はアトミック操作を使用します：

```dart
// アトミック経験値追加
await _firestore.runTransaction((transaction) async {
  final userDoc = await transaction.get(userRef);
  final currentParams = userDoc.data()?['parameterExp'] ?? {};
  final currentTotal = userDoc.data()?['totalExp'] ?? 0;

  // パラメーター更新
  for (var entry in expMap.entries) {
    currentParams[entry.key] = (currentParams[entry.key] ?? 0) + entry.value;
  }

  // 更新をコミット
  transaction.update(userRef, {
    'parameterExp': currentParams,
    'totalExp': currentTotal + totalExp,
    'lastActiveAt': FieldValue.serverTimestamp(),
  });
});
```

### 2. リアルタイム同期

重要なデータはFirestoreストリームを使用してリアルタイム更新されます：

```dart
// リアルタイムユーザーデータ
Stream<UserModel> watchUser(String odId) {
  return _firestore
      .collection('users')
      .doc(odId)
      .snapshots()
      .map((doc) => UserModel.fromFirestore(doc));
}

// リアルタイムクエスト更新
Stream<List<QuestEntry>> watchQuests(String odId) {
  return _firestore
      .collection('users')
      .doc(odId)
      .collection('quests')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => QuestEntry.fromFirestore(doc))
          .toList());
}
```

## データ移行戦略

### 1. バージョン管理

すべてのモデルは将来の移行のためのバージョン処理を含みます：

```dart
class UserModel {
  // ... 既存フィールド

  // 移行サポート
  static const int currentVersion = 1;

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final version = data['_version'] ?? 1;

    if (version == 1) {
      // バージョン1から現在への移行を処理
      return _migrateFromV1(doc, data);
    }

    return UserModel._fromMap(data);
  }

  Map<String, dynamic> toFirestore() {
    return {
      ..._toMap(),
      '_version': currentVersion,
    };
  }
}
```

### 2. データアーカイブ

古いクエストデータはパフォーマンス維持のためにアーカイブ可能です：

```dart
// 3ヶ月以上前のクエストをアーカイブ
Future<void> archiveOldQuests(String odId) async {
  final threeMonthsAgo = DateTime.now().subtract(Duration(days: 90));
  final oldQuests = await _questRepository.getQuestsBefore(odId, threeMonthsAgo);

  for (final quest in oldQuests) {
    await _archiveCollection.doc(quest.id).set(quest.toFirestore());
    await _questsCollection.doc(quest.id).delete();
  }
}
```

## データセキュリティ考慮事項

### 1. アクセス制御
- ユーザーデータはUIDで分離
- クエストサブコレクションは親ドキュメントのセキュリティを継承
- ローカルキャッシュに機密データなし

### 2. データ暗号化
- APIキーは保存時に暗号化
- ユーザー通信はHTTPS経由で暗号化
- ローカルストレージはプラットフォームセキュリティ基準に従う

### 3. プライバシー設定
- 機密エントリーの匿名オプション
- データ共有のきめ細かな制御
- GDPR準拠データ処理

このデータモデルアーキテクチャにより、DiaryQuestのゲーム化ジャーナリングシステムの強固な基盤が提供され、現在の機能をサポートしながら将来の拡張にも対応できます。
