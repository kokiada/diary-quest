import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

/// 音声認識サービス
class SpeechService {
  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;

  /// 利用可能かどうか
  bool get isAvailable => _isInitialized;

  /// 録音中かどうか
  bool get isListening => _speechToText.isListening;

  /// 初期化
  Future<bool> initialize() async {
    _isInitialized = await _speechToText.initialize(
      onError: (error) => print('SpeechToText Error: $error'),
      onStatus: (status) => print('SpeechToText Status: $status'),
    );
    return _isInitialized;
  }

  /// 録音開始
  Future<void> startListening({
    required Function(String text, bool isFinal) onResult,
    String localeId = 'ja_JP',
  }) async {
    if (!_isInitialized) {
      throw Exception('SpeechService not initialized');
    }

    await _speechToText.listen(
      onResult: (SpeechRecognitionResult result) {
        onResult(result.recognizedWords, result.finalResult);
      },
      localeId: localeId,
      listenMode: ListenMode.dictation,
      partialResults: true,
      cancelOnError: false,
    );
  }

  /// 録音停止
  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  /// キャンセル
  Future<void> cancel() async {
    await _speechToText.cancel();
  }

  /// 利用可能なロケール一覧
  Future<List<LocaleName>> getLocales() async {
    return await _speechToText.locales();
  }

  /// 破棄
  void dispose() {
    _speechToText.cancel();
  }
}
