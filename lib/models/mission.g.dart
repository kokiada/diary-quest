// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MissionImpl _$$MissionImplFromJson(Map<String, dynamic> json) =>
    _$MissionImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$MissionTypeEnumMap, json['type']),
      difficulty: $enumDecode(_$MissionDifficultyEnumMap, json['difficulty']),
      status: $enumDecode(_$MissionStatusEnumMap, json['status']),
      targetValue: (json['targetValue'] as num).toInt(),
      currentValue: (json['currentValue'] as num?)?.toInt() ?? 0,
      rewardExp: (json['rewardExp'] as num?)?.toInt() ?? 0,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      claimedAt: json['claimedAt'] == null
          ? null
          : DateTime.parse(json['claimedAt'] as String),
    );

Map<String, dynamic> _$$MissionImplToJson(_$MissionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'type': _$MissionTypeEnumMap[instance.type]!,
      'difficulty': _$MissionDifficultyEnumMap[instance.difficulty]!,
      'status': _$MissionStatusEnumMap[instance.status]!,
      'targetValue': instance.targetValue,
      'currentValue': instance.currentValue,
      'rewardExp': instance.rewardExp,
      'completedAt': instance.completedAt?.toIso8601String(),
      'claimedAt': instance.claimedAt?.toIso8601String(),
    };

const _$MissionTypeEnumMap = {
  MissionType.questCount: 'questCount',
  MissionType.totalExp: 'totalExp',
  MissionType.consecutiveDays: 'consecutiveDays',
  MissionType.parameterExp: 'parameterExp',
};

const _$MissionDifficultyEnumMap = {
  MissionDifficulty.easy: 'easy',
  MissionDifficulty.normal: 'normal',
  MissionDifficulty.hard: 'hard',
};

const _$MissionStatusEnumMap = {
  MissionStatus.notStarted: 'notStarted',
  MissionStatus.inProgress: 'inProgress',
  MissionStatus.completed: 'completed',
  MissionStatus.claimed: 'claimed',
};
