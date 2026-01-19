import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../quest/quest_report_screen.dart';
import 'widgets/player_header.dart';
import 'widgets/diary_input_card.dart';
import 'widgets/stats_row.dart';
import 'widgets/spirit_buddy_message.dart';

/// ホーム画面 - MVPシンプルデザイン
/// クエスト記録機能が中心
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景グラデーション
          _buildBackground(),

          // メインコンテンツ
          _buildContent(),
        ],
      ),
      floatingActionButton: _buildMicButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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

  Widget _buildContent() {
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

  Widget _buildMicButton(BuildContext context) {
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
          onTap: () => _startQuestReport(context),
          customBorder: const CircleBorder(),
          child: const Icon(Icons.mic, size: 28, color: Colors.white),
        ),
      ),
    );
  }

  void _startQuestReport(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const QuestReportScreen(),
        fullscreenDialog: true,
      ),
    );
  }
}

