# Animation Assets

このディレクトリにはLottieアニメーションファイルを配置します。

## 必要なアニメーション

- `level_up.json` - レベルアップ時のアニメーション
- `skill_unlock.json` - スキル解放時のアニメーション
- `job_unlock.json` - ジョブ解放時のアニメーション
- `base_evolution.json` - 拠点進化時のアニメーション

## 配置手順

1. Lottie JSONファイルを準備する
2. このディレクトリに配置する
3. アプリを再ビルドする (`flutter run`)

## 使用方法

```dart
import 'package:lottie/lottie.dart';

Lottie.asset('assets/animations/level_up.json');
```

## 注意事項

- アニメーションファイルはGitにコミットされます
- Lottieファイルサイズは適切に最適化してください
- Lottieファイルは https://lottiefiles.com/ などから入手可能
