import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/user.dart';

/// ナビゲーター（相棒）ウィジェット
class NavigatorWidget extends StatelessWidget {
  const NavigatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // デフォルトは軍師
    final navigator = Navigators.all[NavigatorType.strategist]!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // ナビゲーターアイコン
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
            ),
            child: const Icon(
              Icons.psychology,
              size: 32,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 16),

          // メッセージ
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  navigator.nameJa,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: AppColors.secondary),
                ),
                const SizedBox(height: 4),
                Text(
                  _getGreetingMessage(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return '今日の作戦を立てよう。まずは状況を整理するところから始めるのが良い。';
    } else if (hour < 18) {
      return '午後の戦況はどうだ？困難に直面しても、冷静に分析すれば道は開ける。';
    } else {
      return '今日の戦果を報告してくれ。どんな経験も、次への糧になる。';
    }
  }
}
