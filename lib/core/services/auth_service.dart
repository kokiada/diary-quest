import 'package:firebase_auth/firebase_auth.dart';

/// Firebase Authentication サービス
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 現在のユーザー
  User? get currentUser => _auth.currentUser;

  /// 認証状態のストリーム
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// メール/パスワードでサインアップ
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// メール/パスワードでログイン
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// ログアウト
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// パスワードリセットメール送信
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  /// 表示名を更新
  Future<void> updateDisplayName(String displayName) async {
    await currentUser?.updateDisplayName(displayName);
  }
}
