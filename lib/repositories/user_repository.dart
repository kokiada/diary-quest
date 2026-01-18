import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

/// ユーザーリポジトリ
class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  /// ユーザーを取得
  Future<UserModel?> getUser(String odId) async {
    final doc = await _usersCollection.doc(odId).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  /// ユーザーを作成
  Future<void> createUser(UserModel user) async {
    await _usersCollection.doc(user.id).set(user.toFirestore());
  }

  /// ユーザーを更新
  Future<void> updateUser(UserModel user) async {
    await _usersCollection.doc(user.id).update(user.toFirestore());
  }

  /// ナビゲーターを更新
  Future<void> updateNavigator(String odId, NavigatorType navigator) async {
    await _usersCollection.doc(odId).update({
      'selectedNavigator': navigator.name,
      'lastActiveAt': Timestamp.now(),
    });
  }

  /// 表示名を更新
  Future<void> updateDisplayName(String odId, String displayName) async {
    await _usersCollection.doc(odId).update({
      'displayName': displayName,
      'lastActiveAt': Timestamp.now(),
    });
  }

  /// 経験値を追加
  Future<void> addExperience(
    String odId,
    Map<String, int> parameterExp,
    int totalExp,
  ) async {
    final doc = await _usersCollection.doc(odId).get();
    if (!doc.exists) return;

    final data = doc.data()!;
    final currentParams = Map<String, int>.from(data['parameterExp'] ?? {});
    final currentTotal = data['totalExp'] as int? ?? 0;

    // パラメーター経験値を加算
    for (var entry in parameterExp.entries) {
      currentParams[entry.key] = (currentParams[entry.key] ?? 0) + entry.value;
    }

    await _usersCollection.doc(odId).update({
      'parameterExp': currentParams,
      'totalExp': currentTotal + totalExp,
      'lastActiveAt': Timestamp.now(),
    });
  }

  /// 連続日数を更新
  Future<void> updateConsecutiveDays(String odId, int days) async {
    await _usersCollection.doc(odId).update({
      'consecutiveDays': days,
      'lastActiveAt': Timestamp.now(),
    });
  }

  /// 拠点レベルを更新
  Future<void> updateBaseLevel(String odId, int level) async {
    await _usersCollection.doc(odId).update({
      'baseLevel': level,
      'lastActiveAt': Timestamp.now(),
    });
  }

  /// ユーザーの変更をリッスン
  Stream<UserModel?> watchUser(String odId) {
    return _usersCollection.doc(odId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    });
  }

  /// 通知設定を更新
  Future<void> updateNotificationSettings(
    String userId, {
    bool? morningBuffEnabled,
    bool? eveningReportEnabled,
    int? morningBuffHour,
    int? morningBuffMinute,
    int? eveningReportHour,
    int? eveningReportMinute,
  }) async {
    try {
      final updateData = <String, dynamic>{};

      if (morningBuffEnabled != null) {
        updateData['morningBuffEnabled'] = morningBuffEnabled;
      }
      if (eveningReportEnabled != null) {
        updateData['eveningReportEnabled'] = eveningReportEnabled;
      }
      if (morningBuffHour != null) {
        updateData['morningBuffHour'] = morningBuffHour;
      }
      if (morningBuffMinute != null) {
        updateData['morningBuffMinute'] = morningBuffMinute;
      }
      if (eveningReportHour != null) {
        updateData['eveningReportHour'] = eveningReportHour;
      }
      if (eveningReportMinute != null) {
        updateData['eveningReportMinute'] = eveningReportMinute;
      }

      if (updateData.isNotEmpty) {
        updateData['lastActiveAt'] = FieldValue.serverTimestamp();
        await _usersCollection.doc(userId).update(updateData);
      }
    } catch (e) {
      throw UserRepositoryException('Failed to update notification settings: $e');
    }
  }
}

/// ユーザーリポジトリ例外
class UserRepositoryException implements Exception {
  final String message;
  UserRepositoryException(this.message);

  @override
  String toString() => 'UserRepositoryException: $message';
}
