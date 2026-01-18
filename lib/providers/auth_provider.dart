import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/auth_service.dart';
import '../models/user.dart';

/// 認証状態を管理するProvider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
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

  AuthNotifier() : super(const AuthState()) {
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
    // TODO: Firestoreからユーザーモデルを読み込む
    // 仮のユーザーモデルを作成
    final userModel = UserModel(
      id: odId,
      email: _authService.currentUser?.email ?? '',
      displayName: _authService.currentUser?.displayName ?? '冒険者',
      selectedNavigator: NavigatorType.strategist,
      createdAt: DateTime.now(),
      lastActiveAt: DateTime.now(),
    );
    state = state.copyWith(userModel: userModel);
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
    if (state.userModel == null) return;

    final updatedUser = state.userModel!.copyWith(selectedNavigator: navigator);
    state = state.copyWith(userModel: updatedUser);

    // TODO: Firestoreに保存
  }
}
