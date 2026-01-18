import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/quest_provider.dart';
import '../../models/quest_entry.dart';

/// 冒険譚（ウィークリーレポート）画面
class WeeklyReportScreen extends ConsumerWidget {
  const WeeklyReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyQuestsAsync = ref.watch(weeklyQuestsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('冒険譚', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text('あなたの1週間の物語', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),

              weeklyQuestsAsync.when(
                data: (quests) => _buildWeeklyContent(context, quests),
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.secondary),
                ),
                error: (e, _) => Center(child: Text('エラー: $e')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyContent(BuildContext context, List<QuestEntry> quests) {
    if (quests.isEmpty) {
      return _buildEmptyState(context);
    }

    // 週の統計を計算
    final totalExp = quests.fold<int>(0, (sum, q) => sum + q.totalEarnedExp);
    final questCount = quests.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 章タイトル
        _buildChapterHeader(context, questCount),
        const SizedBox(height: 24),

        // 週間統計
        _buildWeeklyStats(context, totalExp, questCount),
        const SizedBox(height: 24),

        // 日別エントリ
        Text('冒険の記録', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        ...quests.map((quest) => _buildQuestCard(context, quest)),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_stories,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'まだ物語は始まっていません',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'クエスト報告を行うと\nここに冒険譚が記録されます',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildChapterHeader(BuildContext context, int questCount) {
    final now = DateTime.now();
    final weekNumber = (now.difference(DateTime(now.year, 1, 1)).inDays / 7)
        .ceil();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '第${weekNumber}章',
            style: const TextStyle(
              color: AppColors.secondary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getChapterTitle(questCount),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getChapterTitle(int questCount) {
    if (questCount >= 7) return '不屈の冒険者';
    if (questCount >= 5) return '成長の軌跡';
    if (questCount >= 3) return '挑戦の日々';
    return '始まりの一歩';
  }

  Widget _buildWeeklyStats(BuildContext context, int totalExp, int questCount) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            icon: Icons.description,
            label: 'クエスト',
            value: '$questCount件',
            color: AppColors.social,
          ),
          _buildStatItem(
            context,
            icon: Icons.star,
            label: '獲得EXP',
            value: '$totalExp',
            color: AppColors.secondary,
          ),
          _buildStatItem(
            context,
            icon: Icons.trending_up,
            label: '平均',
            value: questCount > 0 ? '${(totalExp / questCount).round()}' : '0',
            color: AppColors.tactics,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildQuestCard(BuildContext context, QuestEntry quest) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                quest.formattedDate,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '+${quest.totalEarnedExp} EXP',
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            quest.summary,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
