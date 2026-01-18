import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/quest_entry.dart';

/// 伏線回収（過去の悩み記憶）サービス
class FollowUpService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 過去の未解決課題を検索
  Future<List<FollowUpItem>> findUnresolvedIssues(String odId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(odId)
        .collection('quests')
        .orderBy('createdAt', descending: true)
        .limit(30)
        .get();

    final issues = <FollowUpItem>[];

    for (var doc in snapshot.docs) {
      final quest = QuestEntry.fromFirestore(doc);
      final keywords = _extractKeywords(quest.rawTranscript);

      for (var keyword in keywords) {
        issues.add(
          FollowUpItem(
            questId: quest.id,
            keyword: keyword,
            originalText: quest.rawTranscript,
            createdAt: quest.createdAt,
          ),
        );
      }
    }

    return issues;
  }

  /// キーワードを抽出（簡易版）
  List<String> _extractKeywords(String text) {
    final keywords = <String>[];

    // ネガティブキーワードを検出
    final negativePatterns = [
      '困っている',
      '悩んでいる',
      '問題',
      '課題',
      '難しい',
      'うまくいかない',
      '失敗',
      '心配',
      '不安',
    ];

    for (var pattern in negativePatterns) {
      if (text.contains(pattern)) {
        // パターン周辺のテキストを抽出
        final index = text.indexOf(pattern);
        final start = (index - 20).clamp(0, text.length);
        final end = (index + 30).clamp(0, text.length);
        keywords.add(text.substring(start, end));
      }
    }

    return keywords;
  }

  /// フォローアップ質問を生成
  String generateFollowUpQuestion(FollowUpItem item) {
    final daysPassed = DateTime.now().difference(item.createdAt).inDays;

    if (daysPassed <= 3) {
      return '先日話していた件、その後どうなりましたか？';
    } else if (daysPassed <= 7) {
      return '一週間ほど前に「${_truncate(item.keyword, 20)}」と話していましたが、進展はありましたか？';
    } else {
      return '以前「${_truncate(item.keyword, 20)}」について話していましたね。今はどうですか？';
    }
  }

  String _truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}

/// フォローアップ項目
class FollowUpItem {
  final String questId;
  final String keyword;
  final String originalText;
  final DateTime createdAt;

  FollowUpItem({
    required this.questId,
    required this.keyword,
    required this.originalText,
    required this.createdAt,
  });
}
