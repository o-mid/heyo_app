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
  String get callId => throw _privateConstructorUsedError;
  CallType get type => throw _privateConstructorUsedError;
  CallStatus get status => throw _privateConstructorUsedError;
  List<CallHistoryParticipantModel> get participants =>
      throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;

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
      {String callId,
      CallType type,
      CallStatus status,
      List<CallHistoryParticipantModel> participants,
      DateTime startDate,
      DateTime? endDate});
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
    Object? callId = null,
    Object? type = null,
    Object? status = null,
    Object? participants = null,
    Object? startDate = null,
    Object? endDate = freezed,
  }) {
    return _then(_value.copyWith(
      callId: null == callId
          ? _value.callId
          : callId // ignore: cast_nullable_to_non_nullable
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
              as List<CallHistoryParticipantModel>,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      {String callId,
      CallType type,
      CallStatus status,
      List<CallHistoryParticipantModel> participants,
      DateTime startDate,
      DateTime? endDate});
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
    Object? callId = null,
    Object? type = null,
    Object? status = null,
    Object? participants = null,
    Object? startDate = null,
    Object? endDate = freezed,
  }) {
    return _then(_$CallHistoryModelImpl(
      callId: null == callId
          ? _value.callId
          : callId // ignore: cast_nullable_to_non_nullable
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
              as List<CallHistoryParticipantModel>,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$CallHistoryModelImpl implements _CallHistoryModel {
  const _$CallHistoryModelImpl(
      {required this.callId,
      required this.type,
      required this.status,
      required final List<CallHistoryParticipantModel> participants,
      required this.startDate,
      this.endDate})
      : _participants = participants;

  factory _$CallHistoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CallHistoryModelImplFromJson(json);

  @override
  final String callId;
  @override
  final CallType type;
  @override
  final CallStatus status;
  final List<CallHistoryParticipantModel> _participants;
  @override
  List<CallHistoryParticipantModel> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  @override
  final DateTime startDate;
  @override
  final DateTime? endDate;

  @override
  String toString() {
    return 'CallHistoryModel(callId: $callId, type: $type, status: $status, participants: $participants, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CallHistoryModelImpl &&
            (identical(other.callId, callId) || other.callId == callId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._participants, _participants) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, callId, type, status,
      const DeepCollectionEquality().hash(_participants), startDate, endDate);

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
      {required final String callId,
      required final CallType type,
      required final CallStatus status,
      required final List<CallHistoryParticipantModel> participants,
      required final DateTime startDate,
      final DateTime? endDate}) = _$CallHistoryModelImpl;

  factory _CallHistoryModel.fromJson(Map<String, dynamic> json) =
      _$CallHistoryModelImpl.fromJson;

  @override
  String get callId;
  @override
  CallType get type;
  @override
  CallStatus get status;
  @override
  List<CallHistoryParticipantModel> get participants;
  @override
  DateTime get startDate;
  @override
  DateTime? get endDate;
  @override
  @JsonKey(ignore: true)
  _$$CallHistoryModelImplCopyWith<_$CallHistoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
