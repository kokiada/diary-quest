import 'package:flutter/material.dart';

/// スピリットバディのメッセージ - モダンデザイン
class SpiritBuddyMessage extends StatelessWidget {
  const SpiritBuddyMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // スピリットバディのアイコン
        Stack(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(4),
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuBQ4HE_Ke6WzNMptcCGnOnQYIMReIDu_Y0Vs3ulDG8y6-K8KQZXNZxoSNL-kYwjvnr1zxSUlCw2lN--yqlWjDy-mfUKXZ4N5CtKyOLC0OCAE3Aj0_OGNrkSHFl_EB87D1JT_WO0W_xlCrfbyw1tInDpY8CDBCX83NxbC8oNuDk9I2RlFjYBdlz8SzMMP8MiUQaqQFj4-Gsxb91dTWJbOElGrUnQNgnO2VWqbMqgwOTkwVzbmlSfBMf88HwXfKJ5-3FDdHa4PzxCwdM',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.auto_awesome,
                    size: 32,
                    color: Color(0xFF8B5CF6),
                  );
                },
              ),
            ),
            Positioned(
              bottom: -4,
              right: -4,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        // メッセージボックス
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 40,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SPIRIT BUDDY',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF94A3B8),
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      'Just now',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        color: const Color(0xFFCBD5E1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Welcome back! Ready to report your progress for today?',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: const Color(0xFF475569),
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
