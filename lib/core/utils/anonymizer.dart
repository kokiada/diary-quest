/// 匿名化処理ユーティリティ
/// AI送信時に個人名・機密情報を匿名化
class AnonymizerService {
  AnonymizerService();

  /// テキストを匿名化
  String anonymize(String text) {
    var result = text;

    // 人名パターン（日本語の一般的な名前パターン）
    result = _anonymizeNames(result);

    // 会社名パターン
    result = _anonymizeCompanies(result);

    // 電話番号
    result = _anonymizePhoneNumbers(result);

    // メールアドレス
    result = _anonymizeEmails(result);

    // 住所パターン
    result = _anonymizeAddresses(result);

    // 金額
    result = _anonymizeAmounts(result);

    return result;
  }

  String _anonymizeNames(String text) {
    // 「〇〇さん」「〇〇君」「〇〇氏」パターン
    var result = text;
    final patterns = [
      RegExp(r'([一-龥ぁ-んァ-ヶ]{2,4})(さん|くん|君|氏|様|先生)'),
      RegExp(r'([A-Z][a-z]+\s?[A-Z][a-z]+)(さん|氏|様)?'),
    ];

    for (var pattern in patterns) {
      result = result.replaceAllMapped(pattern, (match) {
        final suffix = match.group(2) ?? '';
        return '[人名]$suffix';
      });
    }

    return result;
  }

  String _anonymizeCompanies(String text) {
    var result = text;
    final patterns = [
      RegExp(r'([一-龥ぁ-んァ-ヶA-Za-z]+)(株式会社|有限会社|合同会社|LLC|Inc\.|Corp\.)'),
      RegExp(r'(株式会社|有限会社|合同会社)([一-龥ぁ-んァ-ヶA-Za-z]+)'),
    ];

    for (var pattern in patterns) {
      result = result.replaceAll(pattern, '[会社名]');
    }

    return result;
  }

  String _anonymizePhoneNumbers(String text) {
    final patterns = [RegExp(r'\d{2,4}-\d{2,4}-\d{4}'), RegExp(r'\d{10,11}')];

    var result = text;
    for (var pattern in patterns) {
      result = result.replaceAll(pattern, '[電話番号]');
    }

    return result;
  }

  String _anonymizeEmails(String text) {
    final pattern = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
    return text.replaceAll(pattern, '[メールアドレス]');
  }

  String _anonymizeAddresses(String text) {
    // 都道府県から始まる住所パターン
    final pattern = RegExp(
      r'(東京都|北海道|(?:京都|大阪)府|[一-龥]{2,3}県)[一-龥ぁ-んァ-ヶ0-9\-]+[町村区市]?[0-9\-]+',
    );
    return text.replaceAll(pattern, '[住所]');
  }

  String _anonymizeAmounts(String text) {
    final patterns = [
      RegExp(r'[0-9,]+円'),
      RegExp(r'¥[0-9,]+'),
      RegExp(r'\$[0-9,]+'),
    ];

    var result = text;
    for (var pattern in patterns) {
      result = result.replaceAll(pattern, '[金額]');
    }

    return result;
  }

  /// 匿名化のプレビューを生成（変更箇所をハイライト）
  List<AnonymizedSegment> previewAnonymization(String text) {
    final segments = <AnonymizedSegment>[];
    final anonymized = anonymize(text);

    // 簡易的な差分検出
    if (text != anonymized) {
      segments.add(
        AnonymizedSegment(
          original: text,
          anonymized: anonymized,
          wasAnonymized: true,
        ),
      );
    }

    return segments;
  }
}

/// 匿名化されたセグメント
class AnonymizedSegment {
  final String original;
  final String anonymized;
  final bool wasAnonymized;

  AnonymizedSegment({
    required this.original,
    required this.anonymized,
    required this.wasAnonymized,
  });
}
