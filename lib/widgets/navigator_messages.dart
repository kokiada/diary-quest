import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/user.dart';

/// ナビゲーターメッセージ生成
class NavigatorMessages {
  NavigatorMessages._();

  /// 朝の激励メッセージ
  static String getMorningMessage(NavigatorType type, String userName) {
    switch (type) {
      case NavigatorType.strategist:
        return '$userName、今日の作戦を立てよう。まずは優先順位を明確にすることが重要だ。';
      case NavigatorType.bigBrother:
        return 'おっす！$userName！今日も全力で行こうぜ！お前ならできる！';
      case NavigatorType.spirit:
        return 'おはよう、$userName。今日も穏やかな心で、一歩ずつ進もうね。';
      case NavigatorType.knight:
        return '$userName殿、新たな一日の始まりです。誠実に、正々堂々と参りましょう。';
      case NavigatorType.catFairy:
        return 'にゃ～$userName、朝だにゃ！今日はどんな冒険が待ってるかにゃ？';
    }
  }

  /// 夜の報告依頼メッセージ
  static String getEveningMessage(NavigatorType type, String userName) {
    switch (type) {
      case NavigatorType.strategist:
        return '$userName、今日の戦況を報告してくれ。どんな成果があったか、分析しよう。';
      case NavigatorType.bigBrother:
        return '$userName！今日も頑張ったな！成果を聞かせてくれよ！';
      case NavigatorType.spirit:
        return '$userName、今日もお疲れさま。どんなことがあったか、聞かせてね。';
      case NavigatorType.knight:
        return '$userName殿、本日の戦果をご報告ください。どんな小さな前進も尊いものです。';
      case NavigatorType.catFairy:
        return '$userName～、今日はどうだったにゃ？全部教えてにゃ！';
    }
  }

  /// 分析コメント
  static String getAnalysisComment(
    NavigatorType type,
    int totalExp,
    bool hasNegative,
  ) {
    if (hasNegative) {
      switch (type) {
        case NavigatorType.strategist:
          return '失敗は最良の教師だ。この経験から学び、次に活かそう。';
        case NavigatorType.bigBrother:
          return '失敗したっていいんだ！大事なのは諦めないことだぜ！';
        case NavigatorType.spirit:
          return '辛いこともあったね。でも、それも成長の糧になるよ。';
        case NavigatorType.knight:
          return '騎士道は失敗を恐れません。立ち上がる勇気こそが力です。';
        case NavigatorType.catFairy:
          return 'にゃんだ、大変だったにゃね。でも大丈夫、明日があるにゃ！';
      }
    }

    if (totalExp >= 50) {
      switch (type) {
        case NavigatorType.strategist:
          return '素晴らしい成果だ。君の成長曲線は想定以上だ。';
        case NavigatorType.bigBrother:
          return 'うおおお！最高だ！お前、どんどん強くなってるぞ！';
        case NavigatorType.spirit:
          return 'わぁ、すごい一日だったね。あなたの輝きを感じるよ。';
        case NavigatorType.knight:
          return '見事な戦果です！まさに騎士道の鑑ですな。';
        case NavigatorType.catFairy:
          return 'にゃんと！すごいにゃ！ご褒美のおやつあげるにゃ！';
      }
    }

    switch (type) {
      case NavigatorType.strategist:
        return '着実な進歩だ。継続は複利のように効いてくる。';
      case NavigatorType.bigBrother:
        return 'よくやった！一歩一歩、確実に進んでるぞ！';
      case NavigatorType.spirit:
        return '今日も一歩進めたね。その積み重ねが大きな力になるよ。';
      case NavigatorType.knight:
        return '誠実な努力は必ず報われます。この調子で参りましょう。';
      case NavigatorType.catFairy:
        return '頑張ったにゃ！毎日コツコツが大事にゃよ！';
    }
  }

  /// 録音中の相槌
  static List<String> getInterjections(NavigatorType type) {
    switch (type) {
      case NavigatorType.strategist:
        return ['なるほど', 'ふむ', '興味深い', 'それで？', '続けて'];
      case NavigatorType.bigBrother:
        return ['おお！', 'マジか！', 'すげえ！', 'それでそれで？', 'うんうん！'];
      case NavigatorType.spirit:
        return ['うんうん', 'そうなの', 'へぇ', 'なるほどね', 'それで？'];
      case NavigatorType.knight:
        return ['ふむ', '左様ですか', 'して', '続きを', '心得ました'];
      case NavigatorType.catFairy:
        return ['にゃ？', 'ほほう', 'にゃるほど', 'それでにゃ？', 'にゃんと！'];
    }
  }
}

/// ナビゲーターメッセージ表示ウィジェット
class NavigatorMessageBubble extends StatelessWidget {
  final NavigatorType navigatorType;
  final String message;

  const NavigatorMessageBubble({
    super.key,
    required this.navigatorType,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final info = Navigators.getInfo(navigatorType);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.2),
            ),
            child: Icon(
              _getNavigatorIcon(navigatorType),
              color: _getNavigatorColor(navigatorType),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.nameJa,
                  style: TextStyle(
                    color: _getNavigatorColor(navigatorType),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getNavigatorIcon(NavigatorType type) {
    switch (type) {
      case NavigatorType.strategist:
        return Icons.psychology;
      case NavigatorType.bigBrother:
        return Icons.local_fire_department;
      case NavigatorType.spirit:
        return Icons.spa;
      case NavigatorType.knight:
        return Icons.shield;
      case NavigatorType.catFairy:
        return Icons.pets;
    }
  }

  Color _getNavigatorColor(NavigatorType type) {
    switch (type) {
      case NavigatorType.strategist:
        return AppColors.tactics;
      case NavigatorType.bigBrother:
        return AppColors.execution;
      case NavigatorType.spirit:
        return AppColors.mastery;
      case NavigatorType.knight:
        return AppColors.social;
      case NavigatorType.catFairy:
        return AppColors.frontier;
    }
  }
}
