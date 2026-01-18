import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../quest/quest_report_screen.dart';
import '../quest_history/quest_history_screen.dart';
import '../job_skill/job_skill_screen.dart';
import '../status/status_screen.dart';
import '../settings/settings_screen.dart';
import 'widgets/player_header.dart';
import 'widgets/diary_input_card.dart';
import 'widgets/stats_row.dart';
import 'widgets/spirit_buddy_message.dart';

/// ホーム画面 - 日記中心のモダンデザイン
/// Tab navigation integration for all major screens
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  // List of screens for navigation
  final List<Widget> _screens = [
    const _HomeContent(),
    const QuestHistoryScreen(),
    const JobSkillScreen(),
    const StatusScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景グラデーション
          _buildBackground(),

          // メインコンテンツ - Tab navigation
          _screens[_currentIndex],
        ],
      ),
      floatingActionButton: _currentIndex == 0 ? _buildMicButton() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFFF8FAFC)),
      child: Stack(
        children: [
          // アニメーションする背景ブロブ
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 384,
              height: 384,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.blue.shade100.withValues(alpha: 0.7),
                    Colors.blue.shade50.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 384,
              height: 384,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.purple.shade100.withValues(alpha: 0.7),
                    Colors.purple.shade50.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMicButton() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3B82F6), Color(0xFF06B6D4)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.5),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: _startQuestReport,
          customBorder: const CircleBorder(),
          child: const Icon(Icons.mic, size: 28, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        border: const Border(
          top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 40,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_rounded, 'ホーム'),
                _buildNavItem(1, Icons.auto_awesome, 'クエスト'),
                const SizedBox(width: 64), // マイクボタンのスペース
                _buildNavItem(2, Icons.auto_fix_high, 'ジョブ'),
                _buildNavItem(3, Icons.bar_chart, 'ステータス'),
                _buildNavItem(4, Icons.settings, '設定'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 48,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? const Color(0xFF3B82F6)
                  : const Color(0xFF94A3B8),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF3B82F6)
                    : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startQuestReport() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const QuestReportScreen(),
        fullscreenDialog: true,
      ),
    );
  }
}

/// Home content widget - displayed when tab 0 is selected
class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // プレイヤーヘッダー（レベル、XP、ゴールド）
            const PlayerHeader(),
            const SizedBox(height: 24),

            // 日記入力カード（メイン機能）
            const DiaryInputCard(),
            const SizedBox(height: 24),

            // 統計情報（クエスト、ストリーク、フォーカス）
            const StatsRow(),
            const SizedBox(height: 24),

            // スピリットバディのメッセージ
            const SpiritBuddyMessage(),
          ],
        ),
      ),
    );
  }
}
