import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/parameters.dart';
import '../../providers/user_provider.dart';
import '../job_skill/job_skill_screen.dart';

/// ステータス画面
class StatusScreen extends ConsumerWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final parameterExp = userState.user?.parameterExp ?? {};

    // カテゴリごとの平均レベルを計算
    final categoryValues = ParameterCategory.values.map((category) {
      final categoryInfo = Parameters.categories[category]!;
      if (categoryInfo.parameters.isEmpty) return 0.0;

      final paramLevels = categoryInfo.parameters.map((param) {
        final exp = parameterExp[param] ?? 0;
        return (exp / 20 * 100).clamp(0, 100).toDouble();
      }).toList();

      return paramLevels.isEmpty
          ? 0.0
          : paramLevels.reduce((a, b) => a + b) / paramLevels.length;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ステータス', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),

          // レーダーチャート
          _buildRadarChartCard(context, categoryValues),
          const SizedBox(height: 24),

          // カテゴリ別詳細
          _buildCategoryDetails(context, parameterExp),
          const SizedBox(height: 24),

          // ジョブ表示
          _buildJobCard(context),
        ],
      ),
    );
  }

  Widget _buildRadarChartCard(BuildContext context, List<double> categoryValues) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text('成長レーダー', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.polygon,
                radarBackgroundColor: Colors.transparent,
                borderData: FlBorderData(show: false),
                titleTextStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
                tickCount: 4,
                ticksTextStyle: const TextStyle(
                  color: Colors.transparent,
                  fontSize: 0,
                ),
                tickBorderData: BorderSide(
                  color: AppColors.textSecondary.withValues(alpha: 0.2),
                ),
                gridBorderData: BorderSide(
                  color: AppColors.textSecondary.withValues(alpha: 0.3),
                ),
                getTitle: (index, angle) {
                  final categories = ParameterCategory.values;
                  if (index < categories.length) {
                    final info = Parameters.categories[categories[index]]!;
                    return RadarChartTitle(text: info.nameJa);
                  }
                  return const RadarChartTitle(text: '');
                },
                dataSets: [
                  RadarDataSet(
                    dataEntries: categoryValues
                        .map((value) => RadarEntry(value: value))
                        .toList(),
                    fillColor: AppColors.primary.withValues(alpha: 0.3),
                    borderColor: AppColors.primary,
                    borderWidth: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDetails(BuildContext context, Map<GrowthParameter, int> parameterExp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('カテゴリ別成長', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        ...Parameters.categories.entries.map((entry) {
          return _buildCategoryCard(context, entry.value, parameterExp);
        }),
      ],
    );
  }

  Widget _buildCategoryCard(BuildContext context, CategoryInfo category, Map<GrowthParameter, int> parameterExp) {
    // カテゴリに属するパラメータの平均レベルを計算
    if (category.parameters.isEmpty) {
      return const SizedBox.shrink();
    }

    // パラメータごとの経験値からレベルを計算（0-100）
    final paramLevels = category.parameters.map((param) {
      final exp = parameterExp[param] ?? 0;
      // 経験値をレベルに変換（0-100の範囲に正規化）
      return (exp / 20 * 100).clamp(0, 100).toInt();
    }).toList();

    final value = paramLevels.isEmpty
        ? 0
        : paramLevels.reduce((a, b) => a + b) ~/ paramLevels.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: category.color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(category.icon, color: category.color, size: 24),
              const SizedBox(width: 8),
              Text(
                category.nameJa,
                style: TextStyle(
                  color: category.color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                'Lv.$value',
                style: TextStyle(
                  color: category.color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            category.description,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: value / 100,
            backgroundColor: category.color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(category.color),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const JobSkillScreen()));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppColors.goldGradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.background.withValues(alpha: 0.3),
              ),
              child: const Icon(
                Icons.shield,
                size: 32,
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
                  const Text(
                    '見習い冒険者',
                    style: TextStyle(
                      color: AppColors.background,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
