import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// クエスト結果カード
class QuestResultCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String content;
  final Color? accentColor;

  const QuestResultCard({
    super.key,
    required this.title,
    required this.icon,
    required this.content,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppColors.textPrimary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: accentColor != null
            ? Border.all(color: accentColor!.withValues(alpha: 0.3))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(content, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
