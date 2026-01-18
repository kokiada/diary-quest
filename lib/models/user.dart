import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/parameters.dart';

/// ユーザーモデル
class UserModel {
  final String id;
  final String email;
  final String displayName;
  final NavigatorType selectedNavigator;
  final int totalExp;
  final int consecutiveDays;
  final int baseLevel;
  final Map<GrowthParameter, int> parameterExp;
  final List<String> unlockedSkills;
  final List<String> unlockedJobs;
  final String? currentJob;
  final DateTime createdAt;
  final DateTime lastActiveAt;

  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    required this.selectedNavigator,
    this.totalExp = 0,
    this.consecutiveDays = 0,
    this.baseLevel = 1,
    Map<GrowthParameter, int>? parameterExp,
    List<String>? unlockedSkills,
    List<String>? unlockedJobs,
    this.currentJob,
    required this.createdAt,
    required this.lastActiveAt,
  }) : parameterExp = parameterExp ?? _initParameterExp(),
       unlockedSkills = unlockedSkills ?? [],
       unlockedJobs = unlockedJobs ?? [];

  static Map<GrowthParameter, int> _initParameterExp() {
    return {for (var p in GrowthParameter.values) p: 0};
  }

  /// Firestore からの変換
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      selectedNavigator: NavigatorType.values.firstWhere(
        (e) => e.name == data['selectedNavigator'],
        orElse: () => NavigatorType.strategist,
      ),
      totalExp: data['totalExp'] ?? 0,
      consecutiveDays: data['consecutiveDays'] ?? 0,
      baseLevel: data['baseLevel'] ?? 1,
      parameterExp: _parseParameterExp(data['parameterExp']),
      unlockedSkills: List<String>.from(data['unlockedSkills'] ?? []),
      unlockedJobs: List<String>.from(data['unlockedJobs'] ?? []),
      currentJob: data['currentJob'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastActiveAt: (data['lastActiveAt'] as Timestamp).toDate(),
    );
  }

  static Map<GrowthParameter, int> _parseParameterExp(dynamic data) {
    if (data == null) return _initParameterExp();
    final map = data as Map<String, dynamic>;
    return {for (var p in GrowthParameter.values) p: map[p.name] as int? ?? 0};
  }

  /// Firestore への変換
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'selectedNavigator': selectedNavigator.name,
      'totalExp': totalExp,
      'consecutiveDays': consecutiveDays,
      'baseLevel': baseLevel,
      'parameterExp': {
        for (var entry in parameterExp.entries) entry.key.name: entry.value,
      },
      'unlockedSkills': unlockedSkills,
      'unlockedJobs': unlockedJobs,
      'currentJob': currentJob,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActiveAt': Timestamp.fromDate(lastActiveAt),
    };
  }

  /// コピーウィズ
  UserModel copyWith({
    String? displayName,
    NavigatorType? selectedNavigator,
    int? totalExp,
    int? consecutiveDays,
    int? baseLevel,
    Map<GrowthParameter, int>? parameterExp,
    List<String>? unlockedSkills,
    List<String>? unlockedJobs,
    String? currentJob,
    DateTime? lastActiveAt,
  }) {
    return UserModel(
      id: id,
      email: email,
      displayName: displayName ?? this.displayName,
      selectedNavigator: selectedNavigator ?? this.selectedNavigator,
      totalExp: totalExp ?? this.totalExp,
      consecutiveDays: consecutiveDays ?? this.consecutiveDays,
      baseLevel: baseLevel ?? this.baseLevel,
      parameterExp: parameterExp ?? this.parameterExp,
      unlockedSkills: unlockedSkills ?? this.unlockedSkills,
      unlockedJobs: unlockedJobs ?? this.unlockedJobs,
      currentJob: currentJob ?? this.currentJob,
      createdAt: createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }

  /// 拠点レベル名を取得
  String get baseLevelName {
    switch (baseLevel) {
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
}

/// ナビゲーター（相棒）タイプ
enum NavigatorType {
  strategist, // 軍師
  bigBrother, // アニキ
  spirit, // 精霊
  knight, // 騎士
  catFairy, // 猫妖精
}

/// ナビゲーター情報
class NavigatorInfo {
  final NavigatorType type;
  final String nameJa;
  final String nameEn;
  final String description;
  final String personality;
  final String imagePath;

  const NavigatorInfo({
    required this.type,
    required this.nameJa,
    required this.nameEn,
    required this.description,
    required this.personality,
    required this.imagePath,
  });
}

/// ナビゲーター定義
class Navigators {
  Navigators._();

  static const Map<NavigatorType, NavigatorInfo> all = {
    NavigatorType.strategist: NavigatorInfo(
      type: NavigatorType.strategist,
      nameJa: '軍師',
      nameEn: 'Strategist',
      description: '冷静沈着な参謀。データに基づく分析で成長を導く。',
      personality: 'analytical',
      imagePath: 'assets/images/navigators/strategist.png',
    ),
    NavigatorType.bigBrother: NavigatorInfo(
      type: NavigatorType.bigBrother,
      nameJa: 'アニキ',
      nameEn: 'Big Brother',
      description: '熱血漢の兄貴分。情熱的に背中を押してくれる。',
      personality: 'passionate',
      imagePath: 'assets/images/navigators/big_brother.png',
    ),
    NavigatorType.spirit: NavigatorInfo(
      type: NavigatorType.spirit,
      nameJa: '精霊',
      nameEn: 'Spirit',
      description: '森の精霊。優しく穏やかに心を癒やしてくれる。',
      personality: 'gentle',
      imagePath: 'assets/images/navigators/spirit.png',
    ),
    NavigatorType.knight: NavigatorInfo(
      type: NavigatorType.knight,
      nameJa: '騎士',
      nameEn: 'Knight',
      description: '誠実な騎士。正義感を持って共に挑戦する。',
      personality: 'honorable',
      imagePath: 'assets/images/navigators/knight.png',
    ),
    NavigatorType.catFairy: NavigatorInfo(
      type: NavigatorType.catFairy,
      nameJa: '猫妖精',
      nameEn: 'Cat Fairy',
      description: '気まぐれな猫の妖精。ユーモアで緊張をほぐす。',
      personality: 'playful',
      imagePath: 'assets/images/navigators/cat_fairy.png',
    ),
  };

  /// ナビゲーター情報を取得
  static NavigatorInfo getInfo(NavigatorType type) => all[type]!;
}
