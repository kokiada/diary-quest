import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quest_entry.dart';

/// クエストリポジトリ
class QuestRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _questsCollection(String odId) =>
      _firestore.collection('users').doc(odId).collection('quests');

  /// クエストを保存
  Future<String> saveQuest(String odId, QuestEntry quest) async {
    final doc = await _questsCollection(odId).add(quest.toFirestore());
    return doc.id;
  }

  /// クエストを取得
  Future<QuestEntry?> getQuest(String odId, String questId) async {
    final doc = await _questsCollection(odId).doc(questId).get();
    if (!doc.exists) return null;
    return QuestEntry.fromFirestore(doc);
  }

  /// 今日のクエストを取得
  Future<List<QuestEntry>> getTodayQuests(String odId) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final snapshot = await _questsCollection(odId)
        .where(
          'createdAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
        )
        .where('createdAt', isLessThan: Timestamp.fromDate(endOfDay))
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => QuestEntry.fromFirestore(doc)).toList();
  }

  /// 週間クエストを取得
  Future<List<QuestEntry>> getWeeklyQuests(String odId) async {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    final snapshot = await _questsCollection(odId)
        .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(weekAgo))
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => QuestEntry.fromFirestore(doc)).toList();
  }

  /// 全クエストを取得（ページング）
  Future<List<QuestEntry>> getQuests(
    String odId, {
    int limit = 20,
    DocumentSnapshot? lastDoc,
  }) async {
    var query = _questsCollection(
      odId,
    ).orderBy('createdAt', descending: true).limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => QuestEntry.fromFirestore(doc)).toList();
  }

  /// クエスト数を取得
  Future<int> getQuestCount(String odId) async {
    final snapshot = await _questsCollection(odId).count().get();
    return snapshot.count ?? 0;
  }

  /// クエストの変更をリッスン
  Stream<List<QuestEntry>> watchQuests(String odId, {int limit = 10}) {
    return _questsCollection(odId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => QuestEntry.fromFirestore(doc))
              .toList(),
        );
  }
}
