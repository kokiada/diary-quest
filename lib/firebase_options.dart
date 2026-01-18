import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Firebase設定オプション
/// FlutterFire CLI で生成される内容を手動で作成
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError('macOS platform is not supported');
      case TargetPlatform.android:
        throw UnsupportedError('Android platform is not supported');
      case TargetPlatform.windows:
        throw UnsupportedError('Windows platform is not supported');
      case TargetPlatform.linux:
        throw UnsupportedError('Linux platform is not supported');
      default:
        throw UnsupportedError('Unknown platform is not supported');
    }
  }

  /// Web用Firebase設定
  /// FIXME: 実際のWeb用Firebaseコンソールの値に置き換えてください
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCZhT91b15XNAq5sqo4c7vMr0Axsr2Da2A', // 便宜上iOSと同じキーを使用
    appId: '1:142521310459:web:placeholder',
    messagingSenderId: '142521310459',
    projectId: 'diaryquest-900b2',
    authDomain: 'diaryquest-900b2.firebaseapp.com',
    storageBucket: 'diaryquest-900b2.firebasestorage.app',
    measurementId: 'G-MEASUREMENT_ID',
  );

  /// iOS用Firebase設定
  /// GoogleService-Info.plistの値を使用
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCZhT91b15XNAq5sqo4c7vMr0Axsr2Da2A',
    appId: '1:142521310459:ios:2310859118d88c27e9a45e',
    messagingSenderId: '142521310459',
    projectId: 'diaryquest-900b2',
    storageBucket: 'diaryquest-900b2.firebasestorage.app',
    iosBundleId: 'jp.kokiada.diaryquest',
  );
}
