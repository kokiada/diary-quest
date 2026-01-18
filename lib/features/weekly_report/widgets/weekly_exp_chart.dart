import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/quest_entry.dart';

/// 週間XP推移グラフ
class WeeklyExpChart extends StatelessWidget {
  final List<QuestEntry> quests;

  const WeeklyExpChart({
    super.key,
    required this.quests,
  });

  @override
  Widget build(BuildContext context) {
    if (quests.isEmpty) {
      return const SizedBox.shrink();
    }

    // 日付別に集計
    final dailyData = _aggregateDailyExp(quests);

    if (dailyData.length < 2) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'XP推移',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1.7,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 50,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.textSecondary.withValues(alpha: 0.3),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return _buildBottomTitle(value, dailyData);
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (dailyData.length - 1).toDouble(),
                minY: 0,
                maxY: _calculateMaxY(dailyData),
                lineBarsData: [
                  LineChartBarData(
                    spots: _buildSpots(dailyData),
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.8),
                        AppColors.secondary,
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: AppColors.secondary,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primary.withValues(alpha: 0.2),
                          AppColors.primary.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _aggregateDailyExp(List<QuestEntry> quests) {
    final Map<String, int> dailyExp = {};

    for (final quest in quests) {
      final dateKey = '${quest.createdAt.month}/${quest.createdAt.day}';
      dailyExp[dateKey] = (dailyExp[dateKey] ?? 0) + quest.totalEarnedExp;
    }

    // 日付順にソート
    final sortedKeys = dailyExp.keys.toList()..sort();
    return sortedKeys.map((key) => {
      'date': key,
      'exp': dailyExp[key]!,
    }).toList();
  }

  List<FlSpot> _buildSpots(List<Map<String, dynamic>> dailyData) {
    return List.generate(
      dailyData.length,
      (index) => FlSpot(
        index.toDouble(),
        dailyData[index]['exp']!.toDouble(),
      ),
    );
  }

  double _calculateMaxY(List<Map<String, dynamic>> dailyData) {
    if (dailyData.isEmpty) return 100;
    final maxExp = dailyData.map((d) => d['exp'] as int).reduce((a, b) => a > b ? a : b);
    return ((maxExp / 50).ceil() * 50).toDouble(); // 50単位で切り上げ
  }

  Widget _buildBottomTitle(double value, List<Map<String, dynamic>> dailyData) {
    final index = value.toInt();
    if (index >= dailyData.length) {
      return const SizedBox.shrink();
    }

    return Text(
      dailyData[index]['date'] as String,
      style: const TextStyle(
        fontSize: 10,
        color: AppColors.textSecondary,
      ),
    );
  }
}
