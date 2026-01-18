import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// ログインボーナスダイアログ
class LoginBonusDialog extends StatelessWidget {
  final int consecutiveDays;
  final String? reward;

  const LoginBonusDialog({
    super.key,
    required this.consecutiveDays,
    this.reward,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ヘッダー
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.goldGradient,
              ),
              child: const Icon(
                Icons.celebration,
                size: 48,
                color: AppColors.background,
              ),
            ),
            const SizedBox(height: 24),

            // タイトル
            const Text(
              'ログインボーナス',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 16),

            // 連続日数
            Text(
              '$consecutiveDays日連続ログイン！',
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),

            // メッセージ
            Text(
              _getBonusMessage(consecutiveDays),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // 報酬表示
            if (reward != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.card_giftcard, color: AppColors.secondary),
                    const SizedBox(width: 8),
                    Text(
                      reward!,
                      style: const TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // ボタン
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.background,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  '冒険を始める',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getBonusMessage(int days) {
    if (days >= 30) {
      return '驚異的な継続力！\nあなたは真の冒険者です。';
    } else if (days >= 14) {
      return '素晴らしい習慣化！\n成長が加速しています。';
    } else if (days >= 7) {
      return '一週間達成！\n継続は力なり。';
    } else if (days >= 3) {
      return '良い調子！\nこの調子で続けよう。';
    } else {
      return 'ようこそ、冒険者！\n今日も一歩前進しよう。';
    }
  }
}

/// ログインボーナスを表示
Future<void> showLoginBonusDialog(
  BuildContext context, {
  required int consecutiveDays,
  String? reward,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) =>
        LoginBonusDialog(consecutiveDays: consecutiveDays, reward: reward),
  );
}

/// ログインボーナス報酬の取得
String? getLoginBonusReward(int consecutiveDays) {
  switch (consecutiveDays) {
    case 3:
      return '拠点装飾：旅人の灯火';
    case 7:
      return '拠点装飾：勇者の旗';
    case 14:
      return '拠点装飾：英雄の像';
    case 30:
      return '称号：不屈の冒険者';
    default:
      return null;
  }
}
