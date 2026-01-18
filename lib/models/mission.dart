import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission.freezed.dart';
part 'mission.g.dart';

/// ミッション種別
enum MissionType {
  /// クエスト数
  questCount('クエスト数', 'quest_count'),
  /// 総XP獲得
  totalExp('総XP獲得', 'total_exp'),
  /// 連続記録
  consecutiveDays('連続記録', 'consecutive_days'),
  /// 特定パラメータのXP
  parameterExp('パラメータXP', 'parameter_exp');

  final String nameJa;
  final String key;
  const MissionType(this.nameJa, this.key);
}

/// ミッション難易度
enum MissionDifficulty {
  easy('簡単', 1),
  normal('普通', 2),
  hard('難しい', 3);

  final String nameJa;
  final int tier;
  const MissionDifficulty(this.nameJa, this.tier);
}

/// ミッション状態
enum MissionStatus {
  notStarted('未着手'),
  inProgress('進行中'),
  completed('完了'),
  claimed('受取済');

  final String nameJa;
  const MissionStatus(this.nameJa);
}

@freezed
class Mission with _$Mission {
  const Mission._();

  const factory Mission({
    required String id,
    required String title,
    required String description,
    required MissionType type,
    required MissionDifficulty difficulty,
    required MissionStatus status,
    required int targetValue,
    @Default(0) int currentValue,
    @Default(0) int rewardExp,
    DateTime? completedAt,
    DateTime? claimedAt,
  }) = _Mission;

  factory Mission.fromJson(Map<String, dynamic> json) =>
      _$MissionFromJson(json);

  /// 進捗率 (0.0 ~ 1.0)
  double get progress {
    if (targetValue == 0) return 0.0;
    return (currentValue / targetValue).clamp(0.0, 1.0);
  }

  /// 完了しているか
  bool get isCompleted => currentValue >= targetValue;

  /// 報酬を受け取れるか
  bool get canClaim => isCompleted && status != MissionStatus.claimed;
}
