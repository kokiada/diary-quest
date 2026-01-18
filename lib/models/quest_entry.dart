import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/parameters.dart';

/// クエストエントリ（日記）モデル
class QuestEntry {
  final String id;
  final String odId;
  final DateTime createdAt;
  final String rawTranscript;
  final String summary;
  final String reframedContent;
  final Map<GrowthParameter, int> earnedExp;
  final int totalEarnedExp;
  final String? navigatorComment;

  QuestEntry({
    required this.id,
    required this.odId,
    required this.createdAt,
    required this.rawTranscript,
    required this.summary,
    required this.reframedContent,
    required this.earnedExp,
    required this.totalEarnedExp,
    this.navigatorComment,
  });

  /// Firestore からの変換
  factory QuestEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QuestEntry(
      id: doc.id,
      odId: data['userId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      rawTranscript: data['rawTranscript'] ?? '',
      summary: data['summary'] ?? '',
      reframedContent: data['reframedContent'] ?? '',
      earnedExp: _parseEarnedExp(data['earnedExp']),
      totalEarnedExp: data['totalEarnedExp'] ?? 0,
      navigatorComment: data['navigatorComment'],
    );
  }

  static Map<GrowthParameter, int> _parseEarnedExp(dynamic data) {
    if (data == null) return {};
    final map = data as Map<String, dynamic>;
    return {
      for (var entry in map.entries)
        GrowthParameter.values.firstWhere((e) => e.name == entry.key):
            entry.value as int,
    };
  }

  /// Firestore への変換
  Map<String, dynamic> toFirestore() {
    return {
      'userId': odId,
      'createdAt': Timestamp.fromDate(createdAt),
      'rawTranscript': rawTranscript,
      'summary': summary,
      'reframedContent': reframedContent,
      'earnedExp': {
        for (var entry in earnedExp.entries) entry.key.name: entry.value,
      },
      'totalEarnedExp': totalEarnedExp,
      'navigatorComment': navigatorComment,
    };
  }

  /// 日付フォーマット
  String get formattedDate {
    return '${createdAt.year}/${createdAt.month.toString().padLeft(2, '0')}/${createdAt.day.toString().padLeft(2, '0')}';
  }

  /// 獲得経験値のカテゴリ別合計
  Map<ParameterCategory, int> get expByCategory {
    final result = <ParameterCategory, int>{};
    for (var entry in earnedExp.entries) {
      final category = Parameters.getCategoryFor(entry.key);
      result[category] = (result[category] ?? 0) + entry.value;
    }
    return result;
  }
}
