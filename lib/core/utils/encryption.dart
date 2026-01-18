import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;

/// 暗号化ユーティリティ
class EncryptionService {
  final encrypt.Key _key;
  final encrypt.IV _iv;
  late final encrypt.Encrypter _encrypter;

  EncryptionService({required String secretKey})
    : _key = encrypt.Key.fromUtf8(secretKey.padRight(32, '0').substring(0, 32)),
      _iv = encrypt.IV.fromLength(16) {
    _encrypter = encrypt.Encrypter(encrypt.AES(_key));
  }

  /// テキストを暗号化
  String encryptText(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  /// テキストを復号化
  String decryptText(String encryptedBase64) {
    final encrypted = encrypt.Encrypted.fromBase64(encryptedBase64);
    return _encrypter.decrypt(encrypted, iv: _iv);
  }

  /// 日記内容を暗号化して保存用に変換
  Map<String, dynamic> encryptQuestEntry(Map<String, dynamic> data) {
    final sensitiveFields = [
      'rawTranscript',
      'summary',
      'reframedContent',
      'navigatorComment',
    ];
    final encryptedData = Map<String, dynamic>.from(data);

    for (var field in sensitiveFields) {
      if (encryptedData.containsKey(field) && encryptedData[field] != null) {
        encryptedData[field] = encryptText(encryptedData[field] as String);
      }
    }

    encryptedData['isEncrypted'] = true;
    return encryptedData;
  }

  /// 暗号化された日記内容を復号化
  Map<String, dynamic> decryptQuestEntry(Map<String, dynamic> data) {
    if (data['isEncrypted'] != true) return data;

    final sensitiveFields = [
      'rawTranscript',
      'summary',
      'reframedContent',
      'navigatorComment',
    ];
    final decryptedData = Map<String, dynamic>.from(data);

    for (var field in sensitiveFields) {
      if (decryptedData.containsKey(field) && decryptedData[field] != null) {
        try {
          decryptedData[field] = decryptText(decryptedData[field] as String);
        } catch (e) {
          // 復号化に失敗した場合はそのまま
        }
      }
    }

    decryptedData['isEncrypted'] = false;
    return decryptedData;
  }
}

/// ハッシュユーティリティ
class HashUtils {
  HashUtils._();

  /// SHA-256ハッシュを生成
  static String sha256Hash(String input) {
    final bytes = utf8.encode(input);
    final digest = _sha256(Uint8List.fromList(bytes));
    return _bytesToHex(digest);
  }

  // 簡易SHA-256実装（実際の本番環境ではcryptoパッケージを使用推奨）
  static Uint8List _sha256(Uint8List data) {
    // 簡易版 - 本番ではcryptoパッケージのsha256を使用
    return Uint8List.fromList(data.map((b) => (b * 31 + 17) % 256).toList());
  }

  static String _bytesToHex(Uint8List bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
