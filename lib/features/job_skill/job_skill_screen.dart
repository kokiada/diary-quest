import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/parameters.dart';
import '../../models/job.dart';
import '../../models/skill.dart';
import '../../providers/auth_provider.dart';

/// ジョブ・スキル画面
class JobSkillScreen extends ConsumerWidget {
  const JobSkillScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final userModel = authState.userModel;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('ジョブ・スキル'),
          bottom: const TabBar(
            indicatorColor: AppColors.secondary,
            labelColor: AppColors.secondary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [
              Tab(text: 'ジョブ', icon: Icon(Icons.shield)),
              Tab(text: 'スキル', icon: Icon(Icons.auto_awesome)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildJobsTab(context, userModel),
            _buildSkillsTab(context, userModel),
          ],
        ),
      ),
    );
  }

  Widget _buildJobsTab(BuildContext context, userModel) {
    final currentJob = userModel?.currentJob;
    final unlockedJobs = userModel?.unlockedJobs ?? [];
    final parameterExp = userModel?.parameterExp ?? {};

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 現在のジョブ
          _buildCurrentJobCard(context, currentJob),
          const SizedBox(height: 24),

          // ジョブ一覧
          Text('ジョブ一覧', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          ...Jobs.all.map(
            (job) => _buildJobCard(
              context,
              job,
              isUnlocked: unlockedJobs.contains(job.id),
              isCurrent: currentJob == job.id,
              parameterExp: parameterExp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentJobCard(BuildContext context, String? currentJob) {
    final job = currentJob != null
        ? Jobs.all.firstWhere(
            (j) => j.id == currentJob,
            orElse: () => Jobs.all.first,
          )
        : null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.background.withValues(alpha: 0.3),
            ),
            child: Icon(
              _getJobIcon(job?.id ?? 'novice'),
              size: 36,
              color: AppColors.background,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '現在のジョブ',
                  style: TextStyle(color: AppColors.background, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  job?.nameJa ?? '見習い冒険者',
                  style: const TextStyle(
                    color: AppColors.background,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  job?.description ?? 'まだ旅は始まったばかり',
                  style: TextStyle(
                    color: AppColors.background.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(
    BuildContext context,
    JobDefinition job, {
    required bool isUnlocked,
    required bool isCurrent,
    required Map parameterExp,
  }) {
    // 進捗を計算
    int totalRequired = 0;
    int totalProgress = 0;
    for (var entry in job.requiredParams.entries) {
      totalRequired += entry.value;
      final current = parameterExp[entry.key] as int? ?? 0;
      totalProgress += current.clamp(0, entry.value);
    }
    final progress = totalRequired > 0 ? totalProgress / totalRequired : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnlocked
            ? AppColors.surface
            : AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: isCurrent
            ? Border.all(color: AppColors.secondary, width: 2)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isUnlocked
                      ? AppColors.secondary.withValues(alpha: 0.2)
                      : AppColors.surfaceLight.withValues(alpha: 0.3),
                ),
                child: Icon(
                  _getJobIcon(job.id),
                  color: isUnlocked
                      ? AppColors.secondary
                      : AppColors.textSecondary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          job.nameJa,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isUnlocked
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                        ),
                        if (isUnlocked) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                            size: 16,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      job.description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!isUnlocked) ...[
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.surfaceLight.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.secondary,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 4),
            Text(
              '${(progress * 100).toInt()}% 完了',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSkillsTab(BuildContext context, userModel) {
    final unlockedSkills = userModel?.unlockedSkills ?? [];
    final totalExp = userModel?.totalExp ?? 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 解禁済みスキル数
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSkillStat(
                  context,
                  icon: Icons.auto_awesome,
                  label: '解禁済み',
                  value: '${unlockedSkills.length}',
                  color: AppColors.secondary,
                ),
                _buildSkillStat(
                  context,
                  icon: Icons.lock,
                  label: '未解禁',
                  value:
                      '${Skills.all.length - (unlockedSkills as List).length}',
                  color: AppColors.textSecondary,
                ),
                _buildSkillStat(
                  context,
                  icon: Icons.star,
                  label: '総経験値',
                  value: '$totalExp',
                  color: AppColors.tactics,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // カテゴリ別スキル
          ...ParameterCategory.values.map((category) {
            final categoryInfo = Parameters.categories[category]!;
            final categorySkills = Skills.all
                .where((s) => s.category == category.name)
                .toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      categoryInfo.icon,
                      color: categoryInfo.color,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      categoryInfo.nameJa,
                      style: TextStyle(
                        color: categoryInfo.color,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...categorySkills.map(
                  (skill) => _buildSkillCard(
                    context,
                    skill,
                    isUnlocked: unlockedSkills.contains(skill.id),
                    totalExp: totalExp,
                    color: categoryInfo.color,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSkillStat(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
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

  Widget _buildSkillCard(
    BuildContext context,
    SkillDefinition skill, {
    required bool isUnlocked,
    required int totalExp,
    required Color color,
  }) {
    final progress = (totalExp / skill.requiredTotalExp).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUnlocked
            ? color.withValues(alpha: 0.1)
            : AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: isUnlocked
            ? Border.all(color: color.withValues(alpha: 0.3))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isUnlocked
                  ? color.withValues(alpha: 0.2)
                  : AppColors.surfaceLight.withValues(alpha: 0.3),
            ),
            child: Icon(
              isUnlocked ? Icons.auto_awesome : Icons.lock,
              color: isUnlocked ? color : AppColors.textSecondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  skill.nameJa,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isUnlocked
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
                if (!isUnlocked) ...[
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.surfaceLight.withValues(
                      alpha: 0.3,
                    ),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$totalExp/${skill.requiredTotalExp} EXP',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getJobIcon(String jobId) {
    switch (jobId) {
      case 'strategist_master':
        return Icons.psychology;
      case 'holy_knight':
        return Icons.shield;
      case 'speed_runner':
        return Icons.flash_on;
      case 'innovator':
        return Icons.lightbulb;
      case 'sage':
        return Icons.school;
      case 'diplomat':
        return Icons.handshake;
      case 'architect':
        return Icons.architecture;
      case 'phoenix':
        return Icons.local_fire_department;
      default:
        return Icons.person;
    }
  }
}
