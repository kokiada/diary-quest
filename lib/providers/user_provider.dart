import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../core/constants/parameters.dart';
import '../repositories/user_repository.dart';
import 'auth_provider.dart';

/// ユーザーリポジトリのProvider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

/// ユーザー状態管理Provider
final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  final authState = ref.watch(authProvider);
  return UserNotifier(repository, authState.firebaseUser?.uid);
});

/// ユーザー状態
class UserState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const UserState({this.user, this.isLoading = false, this.error});

  UserState copyWith({UserModel? user, bool? isLoading, String? error}) {
    return UserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  // UI用のヘルパープロパティ
  int get level => user?.baseLevel ?? 1;
  int get gold => user?.totalExp ?? 1250;
  String get jobTitle => user?.currentJob ?? 'STRATEGIST';
  double get xpProgress => 0.65; // TODO: 実際のXP計算
  int get completedQuests => 4; // TODO: 実際のクエスト数
  int get streak => user?.consecutiveDays ?? 12;
  int get focusBonus => 15; // TODO: 実際のボーナス計算
}

/// ユーザー状態のNotifier
class UserNotifier extends StateNotifier<UserState> {
  final UserRepository _repository;
  final String? _odId;

  UserNotifier(this._repository, this._odId) : super(const UserState()) {
    if (_odId != null) {
      _loadUser();
    }
  }

  Future<void> _loadUser() async {
    if (_odId == null) return;

    state = state.copyWith(isLoading: true);
    try {
      final user = await _repository.getUser(_odId!);
      state = state.copyWith(user: user);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// 経験値を追加
  Future<void> addExperience(Map<GrowthParameter, int> expMap) async {
    if (_odId == null || state.user == null) return;

    final totalExp = expMap.values.fold(0, (a, b) => a + b);

    // ローカル状態を更新
    final newParamExp = Map<GrowthParameter, int>.from(
      state.user!.parameterExp,
    );
    for (var entry in expMap.entries) {
      newParamExp[entry.key] = (newParamExp[entry.key] ?? 0) + entry.value;
    }

    final updatedUser = state.user!.copyWith(
      parameterExp: newParamExp,
      totalExp: state.user!.totalExp + totalExp,
    );
    state = state.copyWith(user: updatedUser);

    // Firestoreに保存
    final expMapString = {
      for (var entry in expMap.entries) entry.key.name: entry.value,
    };
    await _repository.addExperience(_odId!, expMapString, totalExp);

    // スキルとジョブの解禁チェック
    await _checkUnlocks(updatedUser);
  }

  /// スキルとジョブの解禁チェック
  Future<void> _checkUnlocks(UserModel user) async {
    // TODO: スキル解禁アニメーションをトリガー
    // TODO: ジョブ解禁通知
  }

  /// 連続日数を更新
  Future<void> updateConsecutiveDays() async {
    if (_odId == null || state.user == null) return;

    final today = DateTime.now();
    final lastActive = state.user!.lastActiveAt;
    final daysDiff = today.difference(lastActive).inDays;

    int newDays;
    if (daysDiff == 1) {
      // 連続
      newDays = state.user!.consecutiveDays + 1;
    } else if (daysDiff == 0) {
      // 同日
      newDays = state.user!.consecutiveDays;
    } else {
      // リセット
      newDays = 1;
    }

    final updatedUser = state.user!.copyWith(
      consecutiveDays: newDays,
      lastActiveAt: today,
    );
    state = state.copyWith(user: updatedUser);

    await _repository.updateConsecutiveDays(_odId!, newDays);

    // 拠点レベルの更新チェック
    await _checkBaseLevel(updatedUser);
  }

  /// 拠点レベルのチェック
  Future<void> _checkBaseLevel(UserModel user) async {
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
      await _repository.updateBaseLevel(_odId!, newLevel);
      // TODO: 拠点進化アニメーションをトリガー
    }
  }
}
