import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/quest_entry.dart';
import '../models/skill.dart';
import '../models/job.dart';
import '../core/constants/parameters.dart';
import '../repositories/user_repository.dart';
import '../repositories/quest_repository.dart';
import 'auth_provider.dart';

/// ユーザーリポジトリのProvider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

/// クエストリポジトリのProvider
final questRepositoryProvider = Provider<QuestRepository>((ref) {
  return QuestRepository();
});

/// グローバルキー for dialog navigation
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// ユーザー状態管理Provider
final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  final questRepository = ref.watch(questRepositoryProvider);
  final authState = ref.watch(authProvider);
  return UserNotifier(
    repository,
    questRepository,
    authState.firebaseUser?.uid,
  );
});

/// ユーザー状態
class UserState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final int todayQuestCount;

  const UserState({
    this.user,
    this.isLoading = false,
    this.error,
    this.todayQuestCount = 0,
  });

  UserState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    int? todayQuestCount,
  }) {
    return UserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      todayQuestCount: todayQuestCount ?? this.todayQuestCount,
    );
  }

  // UI用のヘルパープロパティ
  int get level => user?.baseLevel ?? 1;
  int get gold => user?.totalExp ?? 0;
  String get jobTitle => user?.currentJob ?? 'STRATEGIST';

  /// 現在のレベルでのXP進捗（0.0〜1.0）
  double get xpProgress {
    if (user == null) return 0.0;

    final totalExp = user!.totalExp;
    final currentLevel = user!.baseLevel;

    // レベルごとの必要XP
    final levelThresholds = [0, 200, 500, 1000, 2000]; // レベル1〜5の境界

    if (currentLevel >= 5) return 1.0; // 最大レベル

    final currentLevelMin = levelThresholds[currentLevel - 1];
    final nextLevelMin = levelThresholds[currentLevel];
    final currentLevelExp = totalExp - currentLevelMin;
    final levelExpNeeded = nextLevelMin - currentLevelMin;

    if (levelExpNeeded <= 0) return 1.0;
    return (currentLevelExp / levelExpNeeded).clamp(0.0, 1.0);
  }

  int get completedQuests => todayQuestCount;
  int get streak => user?.consecutiveDays ?? 0;

  /// フォーカスボーナス（連続日数に基づいて計算）
  int get focusBonus {
    final consecutiveDays = user?.consecutiveDays ?? 0;
    if (consecutiveDays >= 30) return 50;
    if (consecutiveDays >= 21) return 40;
    if (consecutiveDays >= 14) return 30;
    if (consecutiveDays >= 7) return 20;
    if (consecutiveDays >= 3) return 10;
    return 0;
  }
}

/// ユーザー状態のNotifier
class UserNotifier extends StateNotifier<UserState> {
  final UserRepository _repository;
  final QuestRepository _questRepository;
  final String? _odId;

  UserNotifier(
    this._repository,
    this._questRepository,
    this._odId,
  ) : super(const UserState()) {
    if (_odId != null) {
      _loadUserData();
    }
  }

  /// ユーザーデータをロード
  Future<void> _loadUserData() async {
    final odId = _odId;
    if (odId == null) return;

    state = state.copyWith(isLoading: true);
    try {
      // ユーザーと今日のクエスト数を並行してロード
      final results = await Future.wait([
        _repository.getUser(odId),
        _questRepository.getTodayQuests(odId),
      ]);

      final user = results[0] as UserModel?;
      final todayQuests = results[1] as List<QuestEntry>;

      state = state.copyWith(
        user: user,
        todayQuestCount: todayQuests.length,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// 経験値を追加
  Future<void> addExperience(Map<GrowthParameter, int> expMap) async {
    final odId = _odId;
    final user = state.user;
    if (odId == null || user == null) return;

    final totalExp = expMap.values.fold(0, (a, b) => a + b);

    // ローカル状態を更新
    final newParamExp = Map<GrowthParameter, int>.from(user.parameterExp);
    for (var entry in expMap.entries) {
      newParamExp[entry.key] = (newParamExp[entry.key] ?? 0) + entry.value;
    }

    final updatedUser = user.copyWith(
      parameterExp: newParamExp,
      totalExp: user.totalExp + totalExp,
    );
    state = state.copyWith(
      user: updatedUser,
      todayQuestCount: state.todayQuestCount + 1,
    );

    // Firestoreに保存
    final expMapString = {
      for (var entry in expMap.entries) entry.key.name: entry.value,
    };
    await _repository.addExperience(odId, expMapString, totalExp);

    // スキルとジョブの解禁チェック
    await _checkUnlocks(updatedUser);
  }

  /// スキルとジョブの解禁チェック
  Future<void> _checkUnlocks(UserModel user) async {
    final odId = _odId;
    if (odId == null) return;

    // チェックするスキルとジョブの定義
    final allSkills = <SkillDefinition>[
      SkillDefinition(
        id: 'critical_thinking',
        nameJa: '批判的思考',
        description: '物事を多角的に分析し、本質を見極める力がついた',
        requiredExp: {'analysis': 30, 'speed': 20},
        category: SkillCategory.tactics,
      ),
      SkillDefinition(
        id: 'fast_learner',
        nameJa: '速習',
        description: '新しいことを素早く習得できるようになった',
        requiredExp: {'analysis': 50, 'speed': 30},
        category: SkillCategory.tactics,
      ),
      // TODO: さらにスキルを追加
    ];

    final allJobs = <JobDefinition>[
      JobDefinition(
        id: 'scholar',
        nameJa: '学者',
        description: '知識を追求する道を選んだ。分析力がさらに向上する',
        requiredLevel: 2,
        requiredExp: {'analysis': 100},
        category: JobCategory.tactics,
      ),
      JobDefinition(
        id: 'strategist',
        nameJa: '戦略家',
        description: '戦略的な思考に長ける。全パラメータバランス型',
        requiredLevel: 3,
        requiredExp: {'analysis': 200, 'speed': 150, 'empathy': 100},
        category: JobCategory.tactics,
      ),
      // TODO: さらにジョブを追加
    ];

    // 新しく解禁されたスキルをチェック
    final newSkills = <SkillDefinition>[];
    for (final skill in allSkills) {
      if (!_isSkillUnlocked(user, skill) && _canUnlockSkill(user, skill)) {
        newSkills.add(skill);
      }
    }

    // 新しく解禁されたジョブをチェック
    final newJobs = <JobDefinition>[];
    for (final job in allJobs) {
      if (!_isJobUnlocked(user, job) && _canUnlockJob(user, job)) {
        newJobs.add(job);
      }
    }

    // もし新しいスキルまたはジョブが解禁されたら
    if (newSkills.isNotEmpty || newJobs.isNotEmpty) {
      // UIに通知するためにグローバルナビゲーターを使用
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (navigatorKey.currentContext != null) {
          _showUnlockDialogs(newSkills, newJobs);
        }
      });
    }
  }

  /// スキルが解禁済みかチェック
  bool _isSkillUnlocked(UserModel user, SkillDefinition skill) {
    return user.unlockedSkills.contains(skill.id);
  }

  /// スキルの解禁条件を満たしているかチェック
  bool _canUnlockSkill(UserModel user, SkillDefinition skill) {
    for (final entry in skill.requiredExp.entries) {
      final currentExp = user.parameterExp[entry.key] ?? 0;
      if (currentExp < entry.value) {
        return false;
      }
    }
    return true;
  }

  /// ジョブが解禁済みかチェック
  bool _isJobUnlocked(UserModel user, JobDefinition job) {
    return user.unlockedJobs.contains(job.id);
  }

  /// ジョブの解禁条件を満たしているかチェック
  bool _canUnlockJob(UserModel user, JobDefinition job) {
    if (user.baseLevel < job.requiredLevel) {
      return false;
    }

    for (final entry in job.requiredExp.entries) {
      final currentExp = user.parameterExp[entry.key] ?? 0;
      if (currentExp < entry.value) {
        return false;
      }
    }
    return true;
  }

  /// 解禁ダイアログを表示
  void _showUnlockDialogs(List<SkillDefinition> newSkills, List<JobDefinition> newJobs) {
    // スキル解禁ダイアログを表示
    for (final skill in newSkills) {
      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (context) => SkillUnlockDialog(skill: skill),
      );
    }

    // ジョブ解禁ダイアログを表示
    for (final job in newJobs) {
      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (context) => JobUnlockDialog(job: job),
      );
    }
  }

  /// 連続日数を更新
  Future<void> updateConsecutiveDays() async {
    final odId = _odId;
    final user = state.user;
    if (odId == null || user == null) return;

    final today = DateTime.now();
    final lastActive = user.lastActiveAt;
    final daysDiff = today.difference(lastActive).inDays;

    int newDays;
    if (daysDiff == 1) {
      // 連続
      newDays = user.consecutiveDays + 1;
    } else if (daysDiff == 0) {
      // 同日
      newDays = user.consecutiveDays;
    } else {
      // リセット
      newDays = 1;
    }

    final updatedUser = user.copyWith(
      consecutiveDays: newDays,
      lastActiveAt: today,
    );
    state = state.copyWith(user: updatedUser);

    await _repository.updateConsecutiveDays(odId, newDays);

    // 拠点レベルの更新チェック
    await _checkBaseLevel(updatedUser);
  }

  /// 拠点レベルのチェック
  Future<void> _checkBaseLevel(UserModel user) async {
    final odId = _odId;
    if (odId == null) return;

    final totalExp = user.totalExp;
    final currentLevel = user.baseLevel;

    int newLevel;
    if (totalExp >= 2000) {
      newLevel = 5; // 城
    } else if (totalExp >= 1000) {
      newLevel = 4; // 館
    } else if (totalExp >= 500) {
      newLevel = 3; // 家
    } else if (totalExp >= 200) {
      newLevel = 2; // 小屋
    } else {
      newLevel = 1; // テント
    }

    if (newLevel > currentLevel) {
      final updatedUser = user.copyWith(baseLevel: newLevel);
      state = state.copyWith(user: updatedUser);
      await _repository.updateBaseLevel(odId, newLevel);
      // TODO: 拠点進化アニメーションをトリガー
    }
  }
}
