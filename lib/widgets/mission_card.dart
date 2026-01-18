import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/mission.dart';

/// ミッションカードウィジェット
class MissionCard extends StatelessWidget {
  final Mission mission;

  const MissionCard({
    super.key,
    required this.mission,
  });

  @override
  Widget build(BuildContext context) {
    final difficultyColor = _getDifficultyColor(mission.difficulty);
    final statusIcon = _getStatusIcon(mission.status);
    final statusColor = _getStatusColor(mission.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: mission.isCompleted
              ? AppColors.success.withValues(alpha: 0.5)
              : AppColors.surfaceLight.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ヘッダー：タイトルとステータス
          Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  mission.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: difficultyColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  mission.difficulty.nameJa,
                  style: TextStyle(
                    color: difficultyColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 説明
          Text(
            mission.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 12),

          // 進捗バー
          _buildProgressBar(context),
          const SizedBox(height: 8),

          // 進捗テキスト
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${mission.currentValue} / ${mission.targetValue}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              if (mission.isCompleted && mission.status != MissionStatus.claimed)
                ElevatedButton(
                  onPressed: () => _claimReward(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                  child: const Text('報酬を受け取る'),
                )
              else if (mission.status == MissionStatus.claimed)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '受取済',
                    style: TextStyle(
                      color: AppColors.success,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                Text(
                  '+${mission.rewardExp} EXP',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: mission.progress,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: mission.isCompleted
                      ? [AppColors.success, AppColors.success.withValues(alpha: 0.8)]
                      : [AppColors.primary, AppColors.secondary],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(MissionDifficulty difficulty) {
    switch (difficulty) {
      case MissionDifficulty.easy:
        return AppColors.social;
      case MissionDifficulty.normal:
        return AppColors.warning;
      case MissionDifficulty.hard:
        return AppColors.error;
    }
  }

  IconData _getStatusIcon(MissionStatus status) {
    switch (status) {
      case MissionStatus.notStarted:
        return Icons.radio_button_unchecked;
      case MissionStatus.inProgress:
        return Icons.pending;
      case MissionStatus.completed:
        return Icons.check_circle;
      case MissionStatus.claimed:
        return Icons.done_all;
    }
  }

  Color _getStatusColor(MissionStatus status) {
    switch (status) {
      case MissionStatus.notStarted:
        return AppColors.textSecondary;
      case MissionStatus.inProgress:
        return AppColors.info;
      case MissionStatus.completed:
        return AppColors.success;
      case MissionStatus.claimed:
        return AppColors.success;
    }
  }

  void _claimReward(BuildContext context) {
    // TODO: 報酬受け取り処理を実装
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('+${mission.rewardExp} EXPを獲得！'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
