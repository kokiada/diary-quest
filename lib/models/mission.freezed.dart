// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mission.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Mission _$MissionFromJson(Map<String, dynamic> json) {
  return _Mission.fromJson(json);
}

/// @nodoc
mixin _$Mission {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  MissionType get type => throw _privateConstructorUsedError;
  MissionDifficulty get difficulty => throw _privateConstructorUsedError;
  MissionStatus get status => throw _privateConstructorUsedError;
  int get targetValue => throw _privateConstructorUsedError;
  int get currentValue => throw _privateConstructorUsedError;
  int get rewardExp => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime? get claimedAt => throw _privateConstructorUsedError;

  /// Serializes this Mission to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Mission
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MissionCopyWith<Mission> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MissionCopyWith<$Res> {
  factory $MissionCopyWith(Mission value, $Res Function(Mission) then) =
      _$MissionCopyWithImpl<$Res, Mission>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    MissionType type,
    MissionDifficulty difficulty,
    MissionStatus status,
    int targetValue,
    int currentValue,
    int rewardExp,
    DateTime? completedAt,
    DateTime? claimedAt,
  });
}

/// @nodoc
class _$MissionCopyWithImpl<$Res, $Val extends Mission>
    implements $MissionCopyWith<$Res> {
  _$MissionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Mission
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? type = null,
    Object? difficulty = null,
    Object? status = null,
    Object? targetValue = null,
    Object? currentValue = null,
    Object? rewardExp = null,
    Object? completedAt = freezed,
    Object? claimedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as MissionType,
            difficulty: null == difficulty
                ? _value.difficulty
                : difficulty // ignore: cast_nullable_to_non_nullable
                      as MissionDifficulty,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as MissionStatus,
            targetValue: null == targetValue
                ? _value.targetValue
                : targetValue // ignore: cast_nullable_to_non_nullable
                      as int,
            currentValue: null == currentValue
                ? _value.currentValue
                : currentValue // ignore: cast_nullable_to_non_nullable
                      as int,
            rewardExp: null == rewardExp
                ? _value.rewardExp
                : rewardExp // ignore: cast_nullable_to_non_nullable
                      as int,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            claimedAt: freezed == claimedAt
                ? _value.claimedAt
                : claimedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MissionImplCopyWith<$Res> implements $MissionCopyWith<$Res> {
  factory _$$MissionImplCopyWith(
    _$MissionImpl value,
    $Res Function(_$MissionImpl) then,
  ) = __$$MissionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    MissionType type,
    MissionDifficulty difficulty,
    MissionStatus status,
    int targetValue,
    int currentValue,
    int rewardExp,
    DateTime? completedAt,
    DateTime? claimedAt,
  });
}

/// @nodoc
class __$$MissionImplCopyWithImpl<$Res>
    extends _$MissionCopyWithImpl<$Res, _$MissionImpl>
    implements _$$MissionImplCopyWith<$Res> {
  __$$MissionImplCopyWithImpl(
    _$MissionImpl _value,
    $Res Function(_$MissionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Mission
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? type = null,
    Object? difficulty = null,
    Object? status = null,
    Object? targetValue = null,
    Object? currentValue = null,
    Object? rewardExp = null,
    Object? completedAt = freezed,
    Object? claimedAt = freezed,
  }) {
    return _then(
      _$MissionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as MissionType,
        difficulty: null == difficulty
            ? _value.difficulty
            : difficulty // ignore: cast_nullable_to_non_nullable
                  as MissionDifficulty,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as MissionStatus,
        targetValue: null == targetValue
            ? _value.targetValue
            : targetValue // ignore: cast_nullable_to_non_nullable
                  as int,
        currentValue: null == currentValue
            ? _value.currentValue
            : currentValue // ignore: cast_nullable_to_non_nullable
                  as int,
        rewardExp: null == rewardExp
            ? _value.rewardExp
            : rewardExp // ignore: cast_nullable_to_non_nullable
                  as int,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        claimedAt: freezed == claimedAt
            ? _value.claimedAt
            : claimedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MissionImpl extends _Mission {
  const _$MissionImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.difficulty,
    required this.status,
    required this.targetValue,
    this.currentValue = 0,
    this.rewardExp = 0,
    this.completedAt,
    this.claimedAt,
  }) : super._();

  factory _$MissionImpl.fromJson(Map<String, dynamic> json) =>
      _$$MissionImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final MissionType type;
  @override
  final MissionDifficulty difficulty;
  @override
  final MissionStatus status;
  @override
  final int targetValue;
  @override
  @JsonKey()
  final int currentValue;
  @override
  @JsonKey()
  final int rewardExp;
  @override
  final DateTime? completedAt;
  @override
  final DateTime? claimedAt;

  @override
  String toString() {
    return 'Mission(id: $id, title: $title, description: $description, type: $type, difficulty: $difficulty, status: $status, targetValue: $targetValue, currentValue: $currentValue, rewardExp: $rewardExp, completedAt: $completedAt, claimedAt: $claimedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MissionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.targetValue, targetValue) ||
                other.targetValue == targetValue) &&
            (identical(other.currentValue, currentValue) ||
                other.currentValue == currentValue) &&
            (identical(other.rewardExp, rewardExp) ||
                other.rewardExp == rewardExp) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.claimedAt, claimedAt) ||
                other.claimedAt == claimedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    type,
    difficulty,
    status,
    targetValue,
    currentValue,
    rewardExp,
    completedAt,
    claimedAt,
  );

  /// Create a copy of Mission
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MissionImplCopyWith<_$MissionImpl> get copyWith =>
      __$$MissionImplCopyWithImpl<_$MissionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MissionImplToJson(this);
  }
}

abstract class _Mission extends Mission {
  const factory _Mission({
    required final String id,
    required final String title,
    required final String description,
    required final MissionType type,
    required final MissionDifficulty difficulty,
    required final MissionStatus status,
    required final int targetValue,
    final int currentValue,
    final int rewardExp,
    final DateTime? completedAt,
    final DateTime? claimedAt,
  }) = _$MissionImpl;
  const _Mission._() : super._();

  factory _Mission.fromJson(Map<String, dynamic> json) = _$MissionImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  MissionType get type;
  @override
  MissionDifficulty get difficulty;
  @override
  MissionStatus get status;
  @override
  int get targetValue;
  @override
  int get currentValue;
  @override
  int get rewardExp;
  @override
  DateTime? get completedAt;
  @override
  DateTime? get claimedAt;

  /// Create a copy of Mission
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MissionImplCopyWith<_$MissionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
