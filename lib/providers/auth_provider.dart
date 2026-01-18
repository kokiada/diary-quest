import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/auth_service.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';

/// ユーザーリポジトリのProvider
final authUserRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

/// 認証状態を管理するProvider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authUserRepositoryProvider);
  return AuthNotifier(repository);
});

/// 認証状態
class AuthState {
  final User? firebaseUser;
  final UserModel? userModel;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.firebaseUser,
    this.userModel,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    User? firebaseUser,
    UserModel? userModel,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      firebaseUser: firebaseUser ?? this.firebaseUser,
      userModel: userModel ?? this.userModel,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get isAuthenticated {
    // デバッグ時は常に認証済みとする
    if (const bool.fromEnvironment('DEBUG_AUTH_OFF', defaultValue: true)) {
      return true;
    }
    return firebaseUser != null;
  }
}

/// 認証状態のNotifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService = AuthService();
  final UserRepository _userRepository;

  AuthNotifier(this._userRepository) : super(const AuthState()) {
    _init();
  }

  void _init() {
    _authService.authStateChanges.listen((user) {
      state = state.copyWith(firebaseUser: user);
      if (user != null) {
        _loadUserModel(user.uid);
      } else if (const bool.fromEnvironment(
        'DEBUG_AUTH_OFF',
        defaultValue: true,
      )) {
        // デバッグ時はダミーユーザーを読み込む
        _loadUserModel('debug-user-id');
      }
    });
  }

  Future<void> _loadUserModel(String odId) async {
    try {
      // Firestoreからユーザーモデルを読み込む
      final userModel = await _userRepository.getUser(odId);

      if (userModel != null) {
        state = state.copyWith(userModel: userModel);
      } else {
        // ユーザードキュメントが存在しない場合は新規作成
        final newUser = UserModel(
          id: odId,
          email: _authService.currentUser?.email ?? '',
          displayName: _authService.currentUser?.displayName ?? '冒険者',
          selectedNavigator: NavigatorType.strategist,
          createdAt: DateTime.now(),
          lastActiveAt: DateTime.now(),
        );
        await _userRepository.createUser(newUser);
        state = state.copyWith(userModel: newUser);
      }
    } catch (e) {
      // エラー時はフォールバックとしてモックユーザーを作成
      final fallbackUser = UserModel(
        id: odId,
        email: _authService.currentUser?.email ?? '',
        displayName: _authService.currentUser?.displayName ?? '冒険者',
        selectedNavigator: NavigatorType.strategist,
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );
      state = state.copyWith(userModel: fallbackUser);
    }
  }

  Future<void> signUp(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authService.signUpWithEmail(email: email, password: password);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authService.signInWithEmail(email: email, password: password);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    state = const AuthState();
  }

  Future<void> updateNavigator(NavigatorType navigator) async {
    if (state.userModel == null || state.firebaseUser == null) return;

    final updatedUser = state.userModel!.copyWith(
      selectedNavigator: navigator,
      lastActiveAt: DateTime.now(),
    );
    state = state.copyWith(userModel: updatedUser);

    // Firestoreに保存
    try {
      await _userRepository.updateNavigator(state.firebaseUser!.uid, navigator);
    } catch (e) {
      // エラー時は状態をロールバック
      state = state.copyWith(userModel: state.userModel);
      rethrow;
    }
  }
}
