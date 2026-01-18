import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/parameters.dart';
import '../../core/services/speech_service.dart';
import '../../providers/quest_provider.dart';
import 'widgets/quest_result_card.dart';

/// クエスト報告画面（音声入力）
class QuestReportScreen extends ConsumerStatefulWidget {
  const QuestReportScreen({super.key});

  @override
  ConsumerState<QuestReportScreen> createState() => _QuestReportScreenState();
}

class _QuestReportScreenState extends ConsumerState<QuestReportScreen>
    with SingleTickerProviderStateMixin {
  final SpeechService _speechService = SpeechService();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    final available = await _speechService.initialize();
    setState(() => _isInitialized = available);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _speechService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final analysisState = ref.watch(questAnalysisProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('クエスト報告'),
        actions: [
          if (analysisState.transcript.isNotEmpty && !analysisState.isAnalyzing)
            TextButton(onPressed: _submitReport, child: const Text('分析')),
        ],
      ),
      body: SafeArea(
        child: analysisState.result != null
            ? _buildResultView(analysisState)
            : _buildRecordingView(analysisState),
      ),
    );
  }

  Widget _buildRecordingView(QuestAnalysisState state) {
    return Column(
      children: [
        // 文字起こし表示エリア
        Expanded(child: _buildTranscriptArea(state)),

        // 録音ボタン
        if (state.isAnalyzing)
          _buildAnalyzingIndicator()
        else
          _buildRecordingControls(state),

        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildTranscriptArea(QuestAnalysisState state) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: state.isRecording
              ? AppColors.secondary.withValues(alpha: 0.5)
              : AppColors.surfaceLight.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: state.transcript.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mic,
                    size: 64,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isInitialized
                        ? 'マイクボタンを押して\n今日の出来事を話してください'
                        : '音声認識を初期化中...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Text(
                state.transcript,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
    );
  }

  Widget _buildRecordingControls(QuestAnalysisState state) {
    return Column(
      children: [
        // 録音状態インジケーター
        if (state.isRecording)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('録音中...', style: TextStyle(color: AppColors.error)),
              ],
            ),
          ),

        const SizedBox(height: 16),

        // 録音ボタン
        GestureDetector(
          onTap: _isInitialized ? _toggleRecording : null,
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: state.isRecording ? _pulseAnimation.value : 1.0,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: state.isRecording
                        ? AppColors.error
                        : (_isInitialized
                              ? AppColors.secondary
                              : AppColors.surfaceLight),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (state.isRecording
                                    ? AppColors.error
                                    : AppColors.secondary)
                                .withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    state.isRecording ? Icons.stop : Icons.mic,
                    size: 36,
                    color: state.isRecording
                        ? Colors.white
                        : AppColors.background,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        Text(
          state.isRecording ? '停止' : '録音開始',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildAnalyzingIndicator() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const CircularProgressIndicator(color: AppColors.secondary),
              const SizedBox(height: 16),
              Text('AIが分析中...', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 8),
              Text('経験値を計算しています', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultView(QuestAnalysisState state) {
    final result = state.result!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 成功メッセージ
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.celebration,
                  color: AppColors.background,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'クエスト完了！',
                        style: TextStyle(
                          color: AppColors.background,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '+${result.totalExp} EXP',
                        style: const TextStyle(
                          color: AppColors.background,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 戦果サマリー
          QuestResultCard(
            title: '本日の戦果',
            icon: Icons.description,
            content: result.summary,
          ),
          const SizedBox(height: 16),

          // リフレーミング
          QuestResultCard(
            title: '経験値に変換',
            icon: Icons.psychology,
            content: result.reframedContent,
          ),
          const SizedBox(height: 16),

          // 獲得経験値
          _buildExpBreakdown(result),
          const SizedBox(height: 16),

          // ナビゲーターコメント
          QuestResultCard(
            title: '相棒のコメント',
            icon: Icons.chat_bubble,
            content: result.navigatorComment,
            accentColor: AppColors.secondary,
          ),
          const SizedBox(height: 24),

          // 完了ボタン
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.background,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                '拠点に戻る',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpBreakdown(result) {
    final earnedExp = result.earnedExp as Map<GrowthParameter, int>;
    if (earnedExp.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart, color: AppColors.textPrimary),
              const SizedBox(width: 8),
              Text('獲得経験値', style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 16),
          ...earnedExp.entries.map((entry) {
            final info = Parameters.all[entry.key]!;
            final color = Parameters.getColorFor(entry.key);

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(info.icon, color: color, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      info.nameJa,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '+${entry.value}',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  void _toggleRecording() {
    final notifier = ref.read(questAnalysisProvider.notifier);
    final state = ref.read(questAnalysisProvider);

    if (state.isRecording) {
      _stopRecording();
    } else {
      _startRecording();
    }
  }

  Future<void> _startRecording() async {
    final notifier = ref.read(questAnalysisProvider.notifier);
    notifier.setRecording(true);
    _pulseController.repeat(reverse: true);

    await _speechService.startListening(
      onResult: (text, isFinal) {
        notifier.updateTranscript(text);
      },
    );
  }

  Future<void> _stopRecording() async {
    final notifier = ref.read(questAnalysisProvider.notifier);
    notifier.setRecording(false);
    _pulseController.stop();
    _pulseController.reset();

    await _speechService.stopListening();
  }

  Future<void> _submitReport() async {
    final notifier = ref.read(questAnalysisProvider.notifier);
    final quest = await notifier.analyzeAndSave();

    if (quest != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('クエスト報告を保存しました！'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}
