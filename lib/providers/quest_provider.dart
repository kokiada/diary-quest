import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quest_entry.dart';
import '../repositories/quest_repository.dart';
import '../core/services/openai_service.dart';
import '../core/config/app_config.dart';
import 'auth_provider.dart';

/// クエストリポジトリのProvider
final questRepositoryProvider = Provider<QuestRepository>((ref) {
  return QuestRepository();
});

/// OpenAIサービスのProvider
final openAiServiceProvider = Provider<OpenAIService>((ref) {
  return OpenAIService(
    apiKey: AppConfig.openAiApiKey,
    model: AppConfig.openAiModel,
  );
});

/// 今日のクエスト一覧
final todayQuestsProvider = FutureProvider<List<QuestEntry>>((ref) async {
  final authState = ref.watch(authProvider);
  if (!authState.isAuthenticated) return [];

  final repository = ref.watch(questRepositoryProvider);
  return repository.getTodayQuests(authState.firebaseUser!.uid);
});

/// 週間クエスト一覧
final weeklyQuestsProvider = FutureProvider<List<QuestEntry>>((ref) async {
  final authState = ref.watch(authProvider);
  if (!authState.isAuthenticated) return [];

  final repository = ref.watch(questRepositoryProvider);
  return repository.getWeeklyQuests(authState.firebaseUser!.uid);
});

/// クエスト分析状態
class QuestAnalysisState {
  final bool isRecording;
  final bool isAnalyzing;
  final String transcript;
  final QuestAnalysisResult? result;
  final String? error;

  const QuestAnalysisState({
    this.isRecording = false,
    this.isAnalyzing = false,
    this.transcript = '',
    this.result,
    this.error,
  });

  QuestAnalysisState copyWith({
    bool? isRecording,
    bool? isAnalyzing,
    String? transcript,
    QuestAnalysisResult? result,
    String? error,
  }) {
    return QuestAnalysisState(
      isRecording: isRecording ?? this.isRecording,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      transcript: transcript ?? this.transcript,
      result: result ?? this.result,
      error: error,
    );
  }
}

/// クエスト分析のNotifier
class QuestAnalysisNotifier extends StateNotifier<QuestAnalysisState> {
  final OpenAIService _openAiService;
  final QuestRepository _questRepository;
  final String? _odId;
  final String _navigatorPersonality;

  QuestAnalysisNotifier(
    this._openAiService,
    this._questRepository,
    this._odId,
    this._navigatorPersonality,
  ) : super(const QuestAnalysisState());

  void updateTranscript(String text) {
    state = state.copyWith(transcript: text);
  }

  void appendTranscript(String text) {
    state = state.copyWith(transcript: state.transcript + text);
  }

  void setRecording(bool isRecording) {
    state = state.copyWith(isRecording: isRecording);
  }

  void clearTranscript() {
    state = const QuestAnalysisState();
  }

  Future<QuestEntry?> analyzeAndSave() async {
    if (state.transcript.isEmpty || _odId == null) return null;

    state = state.copyWith(isAnalyzing: true, error: null);

    try {
      // OpenAI APIで分析
      final result = await _openAiService.analyzeQuestReport(
        state.transcript,
        _navigatorPersonality,
      );

      state = state.copyWith(result: result);

      // クエストエントリを作成
      final quest = QuestEntry(
        id: '',
        odId: _odId,
        createdAt: DateTime.now(),
        rawTranscript: state.transcript,
        summary: result.summary,
        reframedContent: result.reframedContent,
        earnedExp: result.earnedExp,
        totalEarnedExp: result.totalExp,
        navigatorComment: result.navigatorComment,
      );

      // Firestoreに保存
      await _questRepository.saveQuest(_odId, quest);

      return quest;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    } finally {
      state = state.copyWith(isAnalyzing: false);
    }
  }
}

/// クエスト分析のProvider
final questAnalysisProvider =
    StateNotifierProvider<QuestAnalysisNotifier, QuestAnalysisState>((ref) {
      final openAiService = ref.watch(openAiServiceProvider);
      final questRepository = ref.watch(questRepositoryProvider);
      final authState = ref.watch(authProvider);

      final personality =
          authState.userModel?.selectedNavigator.name ?? 'analytical';

      return QuestAnalysisNotifier(
        openAiService,
        questRepository,
        authState.firebaseUser?.uid,
        personality,
      );
    });
