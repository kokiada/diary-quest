import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../models/mission.dart';
import '../../widgets/mission_card.dart';

/// ウィークリーミッション画面
class MissionScreen extends ConsumerWidget {
  const MissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: ミッションプロバイダーからデータを取得
    final missions = _getSampleMissions();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ヘッダー
              _buildHeader(context),
              const SizedBox(height: 24),

              // ミッション一覧
              ...missions.map((mission) => MissionCard(mission: mission)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.emoji_events,
              color: AppColors.secondary,
              size: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ウィークリーミッション',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    '今週の目標を達成して報酬をゲット！',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Mission> _getSampleMissions() {
    return [
      Mission(
        id: 'weekly_1',
        title: '今週は7回クエスト達成',
        description: '7日連続でクエストを達成しよう',
        type: MissionType.questCount,
        difficulty: MissionDifficulty.normal,
        status: MissionStatus.inProgress,
        targetValue: 7,
        currentValue: 3,
        rewardExp: 100,
      ),
      Mission(
        id: 'weekly_2',
        title: '総XP500到達',
        description: '今週の獲得総XPが500に到達',
        type: MissionType.totalExp,
        difficulty: MissionDifficulty.hard,
        status: MissionStatus.inProgress,
        targetValue: 500,
        currentValue: 120,
        rewardExp: 150,
      ),
      Mission(
        id: 'weekly_3',
        title: '7日間連続記録',
        description: '毎日クエストを記録して習慣化',
        type: MissionType.consecutiveDays,
        difficulty: MissionDifficulty.hard,
        status: MissionStatus.inProgress,
        targetValue: 7,
        currentValue: 4,
        rewardExp: 200,
      ),
      Mission(
        id: 'weekly_4',
        title: '最初の一歩',
        description: '最初のクエストを達成',
        type: MissionType.questCount,
        difficulty: MissionDifficulty.easy,
        status: MissionStatus.completed,
        targetValue: 1,
        currentValue: 1,
        rewardExp: 50,
      ),
    ];
  }
}
