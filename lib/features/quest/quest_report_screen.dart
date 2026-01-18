import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/parameters.dart';
import '../../core/services/speech_service.dart';
import '../../providers/quest_provider.dart';
import 'widgets/quest_result_card.dart';
import 'widgets/quest_loading_animation.dart';

/// クエスト報告画面（音声入力）
class QuestReportScreen extends ConsumerStatefulWidget {
  const QuestReportScreen({super.key});

  @override
  ConsumerState<QuestReportScreen> createState() => _QuestReportScreenState();
}

class _QuestReportScreenState extends ConsumerState<QuestReportScreen>
    with SingleTickerProviderStateMixin {
  final SpeechService _speechService = SpeechService();
  final TextEditingController _textController = TextEditingController();
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
    _textController.dispose();
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
          if (_textController.text.trim().isNotEmpty && !analysisState.isAnalyzing)
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
    // 音声認識の結果をテキストフィールドに反映
    if (state.transcript.isNotEmpty && _textController.text != state.transcript) {
      _textController.text = state.transcript;
      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: state.isRecording
              ? AppColors.secondary.withValues(alpha: 0.5)
              : (_textController.text.isNotEmpty
                  ? AppColors.primary
                  : AppColors.surfaceLight.withValues(alpha: 0.3)),
          width: 2,
        ),
      ),
      child: _textController.text.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.edit_note,
                    size: 64,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '今日の冒険を記録しよう\n\n声で話すか、テキストで入力できます',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : TextField(
              controller: _textController,
              maxLines: null,
              maxLength: 500,
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
                hintText: '今日何をした？何を感じた？\n\n例：新しいプログラミング言語を学び始めた。最初は難しかったけど、基礎的な文法が理解できて嬉しい。',
                hintStyle: TextStyle(color: AppColors.textSecondary),
              ),
              style: Theme.of(context).textTheme.bodyLarge,
              onChanged: (value) {
                // テキストが変更されたらstateも更新
                if (value != state.transcript) {
                  ref.read(questAnalysisProvider.notifier).updateTranscript(value);
                }
                setState(() {}); // ボーダーの色更新
              },
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
          state.isRecording ? 'タップで停止' : 'タップで録音開始',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildAnalyzingIndicator() {
    return const QuestLoadingAnimation();
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

  Widget _buildExpBreakdown(dynamic result) {
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
