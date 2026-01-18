import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/quest_provider.dart';
import '../../models/quest_entry.dart';
import '../../core/constants/app_colors.dart';

/// クエスト履歴画面
class QuestHistoryScreen extends ConsumerWidget {
  const QuestHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questsAsync = ref.watch(weeklyQuestsProvider);

    return Scaffold(
      body: SafeArea(
        child: questsAsync.when(
          data: (quests) => _buildQuestList(context, quests),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('エラー: $e')),
        ),
      ),
    );
  }

  Widget _buildQuestList(BuildContext context, List<QuestEntry> quests) {
    if (quests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'まだクエストがありません',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    // 日付別にグループ化
    final groupedQuests = _groupQuestsByDate(quests);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groupedQuests.length,
      itemBuilder: (context, index) {
        final date = groupedQuests.keys.elementAt(index);
        final dateQuests = groupedQuests[date]!;

        return _buildDateGroup(context, date, dateQuests);
      },
    );
  }

  Map<DateTime, List<QuestEntry>> _groupQuestsByDate(List<QuestEntry> quests) {
    final Map<DateTime, List<QuestEntry>> grouped = {};
    for (final quest in quests) {
      final date = DateTime(
        quest.createdAt.year,
        quest.createdAt.month,
        quest.createdAt.day,
      );
      grouped.putIfAbsent(date, () => []).add(quest);
    }
    return grouped;
  }

  Widget _buildDateGroup(
    BuildContext context,
    DateTime date,
    List<QuestEntry> quests,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 日付ヘッダー
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            _formatDate(date),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        // クエストカード
        ...quests.map((quest) => _buildQuestCard(context, quest)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildQuestCard(BuildContext context, QuestEntry quest) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(
          quest.summary,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${quest.createdAt.hour}:${quest.createdAt.minute.toString().padLeft(2, '0')}',
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (quest.reframedContent.isNotEmpty) ...[
                  const Text('リフレーム:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(quest.reframedContent),
                  const SizedBox(height: 12),
                ],
                const Text('獲得XP:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: quest.earnedExp.entries.map((entry) {
                    return Chip(
                      label: Text('${entry.key.name}: +${entry.value}'),
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final questDate = DateTime(date.year, date.month, date.day);

    if (questDate == today) {
      return '今日';
    } else if (questDate == yesterday) {
      return '昨日';
    } else {
      return '${date.year}/${date.month}/${date.day}';
    }
  }
}
