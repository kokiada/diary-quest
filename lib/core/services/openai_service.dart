import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/parameters.dart';

/// OpenAI API サービス
class OpenAIService {
  final String apiKey;
  final String model;
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  OpenAIService({required this.apiKey, this.model = 'gpt-4o'});

  /// クエスト報告を分析
  Future<QuestAnalysisResult> analyzeQuestReport(
    String transcript,
    String navigatorPersonality,
  ) async {
    final prompt = _buildAnalysisPrompt(transcript, navigatorPersonality);

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': model,
        'messages': [
          {'role': 'system', 'content': _systemPrompt},
          {'role': 'user', 'content': prompt},
        ],
        'response_format': {'type': 'json_object'},
        'temperature': 0.7,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('OpenAI API error: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    final content = data['choices'][0]['message']['content'];
    return QuestAnalysisResult.fromJson(jsonDecode(content));
  }

  static const String _systemPrompt = '''
あなたは「ダイクエ（Diary Quest）」というアプリのAIアシスタントです。
ユーザーの1日の業務報告を分析し、以下の形式でJSON出力してください：

1. summary: 散漫な語りを「本日の戦果」として日報形式に整理（100-200文字）
2. reframedContent: 失敗や愚痴を「経験値」「次の試練」としてポジティブに変換（100-200文字）
3. earnedExp: 15のパラメーターに対する獲得経験値（0-20の整数）
4. navigatorComment: 選択されたナビゲーターの性格に合わせたコメント（50-100文字）

パラメーター一覧:
- 思考: analysis(分析), creativity(発想), expertise(専門知識)
- 実行: speed(スピード), quality(品質), systematization(仕組み化)
- 対人: negotiation(交渉), empathy(共感), articulation(言語化)
- 自制: resilience(回復力), discipline(規律), metacognition(メタ認知)
- 挑戦: riskTaking(挑戦), unlearning(学習棄却), vision(ビジョン)

報告内容に関連するパラメーターのみ経験値を付与してください。
''';

  String _buildAnalysisPrompt(String transcript, String personality) {
    return '''
【ナビゲーター性格】: $personality
【本日の報告】:
$transcript

上記の報告を分析し、JSON形式で出力してください。
''';
  }
}

/// クエスト分析結果
class QuestAnalysisResult {
  final String summary;
  final String reframedContent;
  final Map<GrowthParameter, int> earnedExp;
  final String navigatorComment;

  QuestAnalysisResult({
    required this.summary,
    required this.reframedContent,
    required this.earnedExp,
    required this.navigatorComment,
  });

  factory QuestAnalysisResult.fromJson(Map<String, dynamic> json) {
    final expMap = <GrowthParameter, int>{};
    final earnedExpJson = json['earnedExp'] as Map<String, dynamic>? ?? {};

    for (var param in GrowthParameter.values) {
      final value = earnedExpJson[param.name];
      if (value != null && value > 0) {
        expMap[param] = value as int;
      }
    }

    return QuestAnalysisResult(
      summary: json['summary'] ?? '',
      reframedContent: json['reframedContent'] ?? '',
      earnedExp: expMap,
      navigatorComment: json['navigatorComment'] ?? '',
    );
  }

  int get totalExp => earnedExp.values.fold(0, (a, b) => a + b);
}
