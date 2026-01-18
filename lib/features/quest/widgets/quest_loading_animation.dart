import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// クエスト分析中のローディングアニメーション
class QuestLoadingAnimation extends StatefulWidget {
  const QuestLoadingAnimation({super.key});

  @override
  State<QuestLoadingAnimation> createState() => _QuestLoadingAnimationState();
}

class _QuestLoadingAnimationState extends State<QuestLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<String> _messages = [
    '冒険を分析中...',
    '経験値を計算中...',
    '成長を記録中...',
    'ナビゲーターが確認中...',
  ];
  int _messageIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    // メッセージを一定時間で切り替え
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        setState(() {
          _messageIndex = (_messageIndex + 1) % _messages.length;
        });
        return true;
      }
      return false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.background, Color(0xFFE0E7FF)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 回転するアニメーション
              SizedBox(
                width: 120,
                height: 120,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _controller.value * 2 * 3.14159,
                      child: CustomPaint(
                        painter: _MagicCirclePainter(_controller.value),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 48),

              // メッセージ
              Text(
                _messages[_messageIndex],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // サブメッセージ
              const Text(
                'しばらくお待ちください...',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 魔法陣のような円を描画
class _MagicCirclePainter extends CustomPainter {
  final double progress;

  _MagicCirclePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 外円
    final outerCircle = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, outerCircle);

    // 回転する弧
    final arcRect = Rect.fromCircle(center: center, radius: radius * 0.8);
    final arcPaint = Paint()
      ..color = AppColors.secondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final startAngle = progress * 2 * 3.14159;
    canvas.drawArc(arcRect, startAngle, 1.5, false, arcPaint);

    // 内側の円
    final innerCircle = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.3, innerCircle);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
