import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../models/quest_entry.dart';
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

  // UI用のヘルパープパティ
  int get level => user?.baseLevel ?? 1;
  int get gold => user?.totalExp ?? 0;
  String get jobTitle => '冒険者'; // MVPシンプルな表示

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
  }

  /// 連続日数を更新
  Future<void> updateConsecutiveDays(int days) async {
    final odId = _odId;
    final user = state.user;
    if (odId == null || user == null) return;

    final updatedUser = user.copyWith(consecutiveDays: days);
    state = state.copyWith(user: updatedUser);

    await _repository.updateConsecutiveDays(odId, days);
  }

  /// 拠点レベルを更新
  Future<void> updateBaseLevel(int level) async {
    final odId = _odId;
    final user = state.user;
    if (odId == null || user == null) return;

    final updatedUser = user.copyWith(baseLevel: level);
    state = state.copyWith(user: updatedUser);

    await _repository.updateBaseLevel(odId, level);
  }

  /// 表示名を更新
  Future<void> updateDisplayName(String displayName) async {
    final odId = _odId;
    final user = state.user;
    if (odId == null || user == null) return;

    final updatedUser = user.copyWith(displayName: displayName);
    state = state.copyWith(user: updatedUser);

    await _repository.updateDisplayName(odId, displayName);
  }

  /// ナビゲーターを更新
  Future<void> updateNavigator(NavigatorType navigator) async {
    final odId = _odId;
    final user = state.user;
    if (odId == null || user == null) return;

    final updatedUser = user.copyWith(selectedNavigator: navigator);
    state = state.copyWith(user: updatedUser);

    await _repository.updateNavigator(odId, navigator);
  }

  /// エラーをクリア
  void clearError() {
    state = state.copyWith(error: null);
  }
}