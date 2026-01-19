import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../core/constants/app_colors.dart';

/// ベースレベルアップダイアログ
class BaseLevelupDialog extends StatefulWidget {
  final int newLevel;

  const BaseLevelupDialog({
    super.key,
    required this.newLevel,
  });

  @override
  State<BaseLevelupDialog> createState() => _BaseLevelupDialogState();
}

class _BaseLevelupDialogState extends State<BaseLevelupDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getBaseName(int level) {
    switch (level) {
      case 1:
        return 'テント';
      case 2:
        return '小屋';
      case 3:
        return '家';
      case 4:
        return '館';
      case 5:
        return '城';
      default:
        return 'テント';
    }
  }

  String _getBaseEmoji(int level) {
    switch (level) {
      case 1:
        return '⛺';
      case 2:
        return '🏠';
      case 3:
        return '🏡';
      case 4:
        return '🏘️';
      case 5:
        return '🏰';
      default:
        return '⛺';
    }
  }

  Color _getBaseColor(int level) {
    switch (level) {
      case 1:
        return AppColors.baseTent;
      case 2:
        return AppColors.baseHut;
      case 3:
        return AppColors.baseHouse;
      case 4:
        return AppColors.baseMansion;
      case 5:
        return AppColors.baseCastle;
      default:
        return AppColors.baseTent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = _getBaseColor(widget.newLevel);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _fadeInAnimation,
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  baseColor.withValues(alpha: 0.8),
                  baseColor,
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: baseColor.withValues(alpha: _glowAnimation.value),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  child: Lottie.asset(
                    'assets/animations/level_up.json',
                    repeat: false,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _getBaseEmoji(widget.newLevel),
                  style: const TextStyle(fontSize: 64),
                ),
                const SizedBox(height: 16),
                const Text(
                  '拠点が進化！',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'レベル ${widget.newLevel}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getBaseName(widget.newLevel),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: baseColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
