// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CallHistoryModel _$CallHistoryModelFromJson(Map<String, dynamic> json) {
  return _CallHistoryModel.fromJson(json);
}

/// @nodoc
mixin _$CallHistoryModel {
  String get id => throw _privateConstructorUsedError;
  String get coreId => throw _privateConstructorUsedError;
  CallType get type => throw _privateConstructorUsedError;
  CallStatus get status => throw _privateConstructorUsedError;
  List<UserModel> get participants => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  double get dataUsageMB => throw _privateConstructorUsedError;
  Duration get duration => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CallHistoryModelCopyWith<CallHistoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CallHistoryModelCopyWith<$Res> {
  factory $CallHistoryModelCopyWith(
          CallHistoryModel value, $Res Function(CallHistoryModel) then) =
      _$CallHistoryModelCopyWithImpl<$Res, CallHistoryModel>;
  @useResult
  $Res call(
      {String id,
      String coreId,
      CallType type,
      CallStatus status,
      List<UserModel> participants,
      DateTime date,
      double dataUsageMB,
      Duration duration});
}

/// @nodoc
class _$CallHistoryModelCopyWithImpl<$Res, $Val extends CallHistoryModel>
    implements $CallHistoryModelCopyWith<$Res> {
  _$CallHistoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? coreId = null,
    Object? type = null,
    Object? status = null,
    Object? participants = null,
    Object? date = null,
    Object? dataUsageMB = null,
    Object? duration = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      coreId: null == coreId
          ? _value.coreId
          : coreId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CallType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CallStatus,
      participants: null == participants
          ? _value.participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<UserModel>,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dataUsageMB: null == dataUsageMB
          ? _value.dataUsageMB
          : dataUsageMB // ignore: cast_nullable_to_non_nullable
              as double,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CallHistoryModelImplCopyWith<$Res>
    implements $CallHistoryModelCopyWith<$Res> {
  factory _$$CallHistoryModelImplCopyWith(_$CallHistoryModelImpl value,
          $Res Function(_$CallHistoryModelImpl) then) =
      __$$CallHistoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String coreId,
      CallType type,
      CallStatus status,
      List<UserModel> participants,
      DateTime date,
      double dataUsageMB,
      Duration duration});
}

/// @nodoc
class __$$CallHistoryModelImplCopyWithImpl<$Res>
    extends _$CallHistoryModelCopyWithImpl<$Res, _$CallHistoryModelImpl>
    implements _$$CallHistoryModelImplCopyWith<$Res> {
  __$$CallHistoryModelImplCopyWithImpl(_$CallHistoryModelImpl _value,
      $Res Function(_$CallHistoryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? coreId = null,
    Object? type = null,
    Object? status = null,
    Object? participants = null,
    Object? date = null,
    Object? dataUsageMB = null,
    Object? duration = null,
  }) {
    return _then(_$CallHistoryModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      coreId: null == coreId
          ? _value.coreId
          : coreId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CallType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CallStatus,
      participants: null == participants
          ? _value._participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<UserModel>,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dataUsageMB: null == dataUsageMB
          ? _value.dataUsageMB
          : dataUsageMB // ignore: cast_nullable_to_non_nullable
              as double,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$CallHistoryModelImpl implements _CallHistoryModel {
  const _$CallHistoryModelImpl(
      {required this.id,
      required this.coreId,
      required this.type,
      required this.status,
      required final List<UserModel> participants,
      required this.date,
      this.dataUsageMB = 0,
      this.duration = Duration.zero})
      : _participants = participants;

  factory _$CallHistoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CallHistoryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String coreId;
  @override
  final CallType type;
  @override
  final CallStatus status;
  final List<UserModel> _participants;
  @override
  List<UserModel> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  @override
  final DateTime date;
  @override
  @JsonKey()
  final double dataUsageMB;
  @override
  @JsonKey()
  final Duration duration;

  @override
  String toString() {
    return 'CallHistoryModel(id: $id, coreId: $coreId, type: $type, status: $status, participants: $participants, date: $date, dataUsageMB: $dataUsageMB, duration: $duration)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CallHistoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.coreId, coreId) || other.coreId == coreId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._participants, _participants) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.dataUsageMB, dataUsageMB) ||
                other.dataUsageMB == dataUsageMB) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      coreId,
      type,
      status,
      const DeepCollectionEquality().hash(_participants),
      date,
      dataUsageMB,
      duration);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CallHistoryModelImplCopyWith<_$CallHistoryModelImpl> get copyWith =>
      __$$CallHistoryModelImplCopyWithImpl<_$CallHistoryModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CallHistoryModelImplToJson(
      this,
    );
  }
}

abstract class _CallHistoryModel implements CallHistoryModel {
  const factory _CallHistoryModel(
      {required final String id,
      required final String coreId,
      required final CallType type,
      required final CallStatus status,
      required final List<UserModel> participants,
      required final DateTime date,
      final double dataUsageMB,
      final Duration duration}) = _$CallHistoryModelImpl;

  factory _CallHistoryModel.fromJson(Map<String, dynamic> json) =
      _$CallHistoryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get coreId;
  @override
  CallType get type;
  @override
  CallStatus get status;
  @override
  List<UserModel> get participants;
  @override
  DateTime get date;
  @override
  double get dataUsageMB;
  @override
  Duration get duration;
  @override
  @JsonKey(ignore: true)
  _$$CallHistoryModelImplCopyWith<_$CallHistoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
