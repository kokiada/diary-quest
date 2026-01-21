# DiaryQuest - UI/UXデザインシステム

## デザイン哲学

DiaryQuestは**ピクセルアートレトロゲーム美学**とモダンでクリーンなインターフェースを採用しています。デザイン哲学は、懐かしいゲーム美学と現代のUI/UXベストプラクティスを組み合わせ、魅力的でユーザーフレンドリーな体験を作り出します。

### コアデザイン原則

1. **ゲームファースト体験**: すべてのインタラクションがRPGアドベンチャーの一部であるように感じる
2. **視覚的フィードバック**: すべてのユーザーアクションとシステム状態に対する明確なインジケーター
3. **アクセシビリティ**: 高コントラスト、読みやすいフォント、直感的なナビゲーション
4. **一貫性**: すべての画面で統一されたデザイン言語
5. **驚き**: ユーザーを驚かせ、楽しませるマイクロインタラクションとアニメーション

## カラーシステム

### プライマリパレット

```dart
// lib/core/constants/app_colors.dart

// ファンタジーインスパイアカラースキーム
static const Color primary = Color(0xFF3B82F6);    // 青 - ファンタジーコバルト
static const Color secondary = Color(0xFFFFD700);  // 金 - 経験値
static const Color background = Color(0xFFF8FAFC);  // ライトクリーム - 紙のような
static const Color surface = Color(0xFFFFFFFF);     // 白 - カード背景
```

### カテゴリーベースのパラメーター色

各成長パラメーターカテゴリーには、認識しやすいように異なる色があります：

| カテゴリー | プライマリ色 | ライトバリアント | 使用例 |
|----------|--------------|---------------|-----------|
| **思考（Tactics）** | `0xFF7C4DFF` (紫) | `0xFFF3E5F5` | 分析力、創造力、専門性 |
| **実行（Execution）** | `0xFFFF5722` (オレンジ) | `0xFFFFF3E0` | スピード、品質、仕組み化 |
| **対人（Social）** | `0xFF00BCD4` (シアン) | `0xFFE0F7FA` | 交渉力、共感力、言語化 |
| **自制（Mastery）** | `0xFF4CAF50` (緑) | `0xFFE8F5E9` | レジリエンス、規律、メタ認知 |
| **挑戦（Frontier）** | `0xFFE91E63` (ピンク) | `0xFFFCE4EC` | リスクテイク、学習棄却、ビジョン |

### ステータス色

```dart
static const Color success = Color(0xFF4CAF50);    // 緑 - 完了したクエスト
static const Color warning = Color(0xFFFFC107);    // 黄 - 警告
static const Color error = Color(0xFFE57373);      // 赤 - エラー
static const Color info = Color(0xFF64B5F6);       // 青 - 情報
```

### ベース進化色（5レベル）

プレイヤーのベースは5つの異なる段階を経て進化します：

| レベル | 名前 | 色 | 視覚スタイル |
|-------|------|-------|--------------|
| 1 | テント | `0xFF795548` (茶) | 基本的な布テクスチャ |
| 2 | 小屋 | `0xFF8D6E63` (ライト茶) | 木造構造 |
| 3 | 家 | `0xFFA1887F` (タン) | モダンな家 |
| 4 | 館 | `0xFFBCAAA4` (シルバー) | 優雅な館 |
| 5 | 城 | `0xFFFFD700` (金) | 壮大な城 |

## タイポグラフィシステム

### フォント階層

DiaryQuestは、レトロゲームフォントとモダンな可読性を組み合わせたカスタムタイポグラフィを使用しています：

```dart
// Google Fonts統合
static TextStyle get _titleTextStyle {
  return GoogleFonts.pressStart2p(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF0F172A),
    letterSpacing: 1.0,
  );
}

static TextStyle get _bodyTextStyle {
  return GoogleFonts.vt323(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF1E293B),
    height: 1.4,
  );
}
```

### フォント使用ガイドライン

| 要素 | フォント | サイズ | ウェイト | 目的 |
|---------|------|------|--------|---------|
| **ヘッダー** | Press Start 2P | 24-48px | Regular | ゲームタイトルヘッダー、強調 |
| **ボディテキスト** | VT323 | 16-24px | Regular | メインコンテンツ、説明 |
| **ラベル** | Inter | 12-14px | Medium | UIラベル、小さなテキスト |
| **数字** | Inter | 14-20px | Bold | ステータス、XP、レベル |
| **ボタン** | Inter | 16px | Semibold | CTAボタン |

### テキストタイプ別色使用

| テキストタイプ | 色 | 使用用途 |
|-----------|-------|-------|
| **プライマリ** | `0xFF0F172A` (ダークネイビー) | メインヘッダー、重要テキスト |
| **セカンダリ** | `0xFF64748B` (グレー) | サブタイトル、説明 |
| **アクセント** | `0xFF3B82F6` (青) | リンク、インタラクティブ要素 |
| **無効** | `0xFFCBD5E1` (ライトグレー) | 無効ステートテキスト |

## コンポーネントライブラリ

### 1. カードコンポーネント

特徴的なスタイリングを持つプライマリUIコンテナ：

```dart
// 標準カード
Card(
  child: Padding(
    padding: const EdgeInsets.all(20),
    child: Content(),
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
    side: BorderSide(
      color: AppColors.primary.withValues(alpha: 0.2),
      width: 2,
    ),
  ),
  elevation: 4,
  color: AppColors.surface,
)

// 特殊グラデーションカード
Container(
  decoration: BoxDecoration(
    gradient: AppColors.goldGradient,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.2),
        blurRadius: 20,
        offset: Offset(0, 10),
      ),
    ],
  ),
  child: Padding(
    padding: const EdgeInsets.all(24),
    child: Content(),
  ),
)
```

### 2. ボタンコンポーネント

#### プライマリボタン（フローティングアクション）
```dart
Container(
  width: 64,
  height: 64,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    gradient: LinearGradient(
      colors: [AppColors.primary, AppColors.primaryLight],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withValues(alpha: 0.5),
        blurRadius: 20,
        spreadRadius: 0,
      ),
    ],
  ),
  child: Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (context) => QuestReportScreen(),
      )),
      borderRadius: BorderRadius.circular(32),
      child: Icon(
        Icons.mic,
        size: 28,
        color: Colors.white,
      ),
    ),
  ),
)
```

#### セカンダリボタン
```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.secondary,
    foregroundColor: AppColors.background,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 0,
  ),
  child: Text(
    '拠点に戻る',
    style: GoogleFonts.pressStart2p(
      fontSize: 14,
      color: AppColors.background,
    ),
  ),
)
```

### 3. プログレスバー

#### XPプログレスバー
```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'EXP',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          '150 / 500',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    ),
    SizedBox(height: 8),
    Container(
      height: 8,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: 0.3, // 30%進行
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    ),
  ],
)
```

### 4. 入力コンポーネント

#### テキスト入力カード
```dart
Container(
  margin: EdgeInsets.all(16),
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: AppColors.primary.withValues(alpha: 0.5),
      width: 2,
    ),
  ),
  child: TextField(
    maxLines: null,
    maxLength: 500,
    decoration: InputDecoration(
      border: InputBorder.none,
      hintText: '今日の冒険を記録しよう...',
      hintStyle: TextStyle(color: AppColors.textSecondary),
    ),
    style: GoogleFonts.vt323(fontSize: 18),
  ),
)
```

#### 録音ボタン
```dart
GestureDetector(
  onTap: () => _toggleRecording(),
  child: AnimatedContainer(
    duration: Duration(milliseconds: 300),
    width: 80,
    height: 80,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: isRecording
          ? AppColors.error
          : AppColors.secondary,
      boxShadow: [
        BoxShadow(
          color: (isRecording
              ? AppColors.error
              : AppColors.secondary)
              .withValues(alpha: 0.4),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ],
    ),
    child: Icon(
      isRecording ? Icons.stop : Icons.mic,
      size: 36,
      color: Colors.white,
    ),
  ),
)
```

## アニメーションシステム

### 1. パルスアニメーション

録音中や重要なアクション中に使用：

```dart
AnimationController _pulseController;
Animation<double> _pulseAnimation;

@override
void initState() {
  super.initState();
  _pulseController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 1500),
  );
  _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
    CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
  );
}

// 録音中の使用
AnimatedBuilder(
  animation: _pulseAnimation,
  builder: (context, child) {
    return Transform.scale(
      scale: isRecording ? _pulseAnimation.value : 1.0,
      child: RecordingButton(),
    );
  },
)
```

### 2. 遷移アニメーション

```dart
// ページ遷移
Navigator.of(context).push(
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return FadeTransition(
        opacity: animation,
        child: QuestReportScreen(),
      );
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        )),
        child: child,
      );
    },
  ),
);
```

### 3. マイクロインタラクション

```dart
// ボタンタップフィードバック
InkWell(
  onTap: () => _handleTap(),
  borderRadius: BorderRadius.circular(16),
  splashColor: AppColors.primary.withValues(alpha: 0.2),
  highlightColor: AppColors.primary.withValues(alpha: 0.1),
  child: Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: AppColors.primary.withValues(alpha: 0.3),
        width: 2,
      ),
    ),
    child: Text('Button'),
  ),
)
```

## レイアウトシステム

### 1. レスポンシブグリッド

```dart
// メインレイアウトグリッド
class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveLayout({
    required this.child,
    this.maxWidth = 600,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width > maxWidth
            ? (MediaQuery.of(context).size.width - maxWidth) / 2
            : 16,
      ),
      child: child,
    );
  }
}
```

### 2. スペーシングシステム

```dart
// アプリ全体で一貫したスペーシング
class Spacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}
```

## アイコンシステム

### 1. カスタムアイコン使用

```dart
// カテゴリーベースのパラメーターアイコン
Icon(
  Icons.analytics,        // 分析 - 思考
  color: AppColors.tactics,
  size: 24,
)

Icon(
  Icons.speed,            // スピード - 実行
  color: AppColors.execution,
  size: 24,
)

Icon(
  Icons.handshake,        // 交渉 - 対人
  color: AppColors.social,
  size: 24,
)

Icon(
  Icons.shield,           // レジリエンス - 自制
  color: AppColors.mastery,
  size: 24,
)

Icon(
  Icons.trending_up,      // リスクテイク - 挑戦
  color: AppColors.frontier,
  size: 24,
)
```

### 2. ステータスアイコン

```dart
// 成功状態
Icon(
  Icons.celebration,
  color: AppColors.success,
  size: 32,
)

// 録音状態
Icon(
  Icons.mic,
  color: AppColors.primary,
  size: 36,
)

// 警告状態
Icon(
  Icons.warning,
  color: AppColors.warning,
  size: 24,
)
```

## 視覚パターン

### 1. カードベースレイアウト

すべてのコンテンツは一貫したスタイリングを持つカードベースパターンに従います：

```
+-------------------------------------+
|                                     |
|  [アイコン] [タイトル]               |
|                                     |
|  [コンテンツ]                        |
|                                     |
|  [アクションボタン]                  |
|                                     |
+-------------------------------------+
```

### 2. プログレスインジケーター

複数のプログレス視覚化パターン：

- **リニアXPバー**: レベル進行用
- **円形プログレス**: 日次目標用
- **積み重ねカード**: �エスト履歴用
- **カテゴリー内訳**: パラメーター分布用

### 3. 階層ビジュアル

- **サイズ**: 大きい要素 = より重要
- **色**: プライマリ色 = メインアクション
- **スペース**: 多くのスペース = より高い重要性
- **シャドウ**: 深いシャドウ = 昇格された要素

## アクセシビリティ考慮事項

### 1. 色コントラスト

すべてのテキストはWCAG AAコントラスト基準を満たしています：
- 白上のプライマリテキスト: 14.5:1比率
- 白上のセカンダリテキスト: 5.4:1比率

### 2. タッチターゲットサイズ

最小タッチターゲット：
- ボタン: 44x44ピクセル
- インタラクティブ要素: 48x48ピクセル
- 要素間のスペース: 最小8ピクセル

### 3. スクリーンリーダーサポート

```dart
Semantics(
  label: '日次クエストを記録',
  hint: '録音を開始するにはダブルタップ',
  child: RecordingButton(),
)

// アクセシブルなラベル
Text(
  'Level ${userState.level}',
  style: TextStyle(fontSize: 24),
  semanticsLabel: 'プレイヤーレベルは${userState.level}',
)
```

## デザイントークン実装

### 1. テーマ拡張

```dart
// カスタムプロパティでThemeDataを拡張
extension ThemeDataExtension on ThemeData {
  Color get primaryColor => primaryColor;
  Color get secondaryColor => colorScheme.secondary;
  TextStyle get gameHeader => GoogleFonts.pressStart2p(
    fontSize: 24,
    color: onSurface,
  );
  TextStyle get gameBody => GoogleFonts.vt323(
    fontSize: 18,
    color: onSurface,
  );
}
```

### 2. レスポンシブブレークポイント

```dart
class Breakpoints {
  static const double mobile = 480;
  static const double tablet = 768;
  static const double desktop = 1024;
}

// 使用
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < Breakpoints.mobile) {
      return MobileLayout();
    } else if (constraints.maxWidth < Breakpoints.tablet) {
      return TabletLayout();
    } else {
      return DesktopLayout();
    }
  },
)
```

この包括的なデザインシステムにより、DiaryQuestはレトロゲーム美学とモダンユーザビリティ標準を両立させた、調和のとれた魅力的なユーザー体験を提供できます。
