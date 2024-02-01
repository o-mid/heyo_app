// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_history_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CallHistoryViewModel {
  String get callId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  List<CallHistoryParticipantViewModel> get participants =>
      throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CallHistoryViewModelCopyWith<CallHistoryViewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CallHistoryViewModelCopyWith<$Res> {
  factory $CallHistoryViewModelCopyWith(CallHistoryViewModel value,
          $Res Function(CallHistoryViewModel) then) =
      _$CallHistoryViewModelCopyWithImpl<$Res, CallHistoryViewModel>;
  @useResult
  $Res call(
      {String callId,
      String type,
      String status,
      List<CallHistoryParticipantViewModel> participants,
      DateTime startDate,
      DateTime? endDate});
}

/// @nodoc
class _$CallHistoryViewModelCopyWithImpl<$Res,
        $Val extends CallHistoryViewModel>
    implements $CallHistoryViewModelCopyWith<$Res> {
  _$CallHistoryViewModelCopyWithImpl(this._value, this._then);

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
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      participants: null == participants
          ? _value.participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<CallHistoryParticipantViewModel>,
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
abstract class _$$CallHistoryViewModelImplCopyWith<$Res>
    implements $CallHistoryViewModelCopyWith<$Res> {
  factory _$$CallHistoryViewModelImplCopyWith(_$CallHistoryViewModelImpl value,
          $Res Function(_$CallHistoryViewModelImpl) then) =
      __$$CallHistoryViewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String callId,
      String type,
      String status,
      List<CallHistoryParticipantViewModel> participants,
      DateTime startDate,
      DateTime? endDate});
}

/// @nodoc
class __$$CallHistoryViewModelImplCopyWithImpl<$Res>
    extends _$CallHistoryViewModelCopyWithImpl<$Res, _$CallHistoryViewModelImpl>
    implements _$$CallHistoryViewModelImplCopyWith<$Res> {
  __$$CallHistoryViewModelImplCopyWithImpl(_$CallHistoryViewModelImpl _value,
      $Res Function(_$CallHistoryViewModelImpl) _then)
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
    return _then(_$CallHistoryViewModelImpl(
      callId: null == callId
          ? _value.callId
          : callId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      participants: null == participants
          ? _value._participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<CallHistoryParticipantViewModel>,
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

class _$CallHistoryViewModelImpl implements _CallHistoryViewModel {
  const _$CallHistoryViewModelImpl(
      {required this.callId,
      required this.type,
      required this.status,
      required final List<CallHistoryParticipantViewModel> participants,
      required this.startDate,
      this.endDate})
      : _participants = participants;

  @override
  final String callId;
  @override
  final String type;
  @override
  final String status;
  final List<CallHistoryParticipantViewModel> _participants;
  @override
  List<CallHistoryParticipantViewModel> get participants {
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
    return 'CallHistoryViewModel(callId: $callId, type: $type, status: $status, participants: $participants, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CallHistoryViewModelImpl &&
            (identical(other.callId, callId) || other.callId == callId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._participants, _participants) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, callId, type, status,
      const DeepCollectionEquality().hash(_participants), startDate, endDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CallHistoryViewModelImplCopyWith<_$CallHistoryViewModelImpl>
      get copyWith =>
          __$$CallHistoryViewModelImplCopyWithImpl<_$CallHistoryViewModelImpl>(
              this, _$identity);
}

abstract class _CallHistoryViewModel implements CallHistoryViewModel {
  const factory _CallHistoryViewModel(
      {required final String callId,
      required final String type,
      required final String status,
      required final List<CallHistoryParticipantViewModel> participants,
      required final DateTime startDate,
      final DateTime? endDate}) = _$CallHistoryViewModelImpl;

  @override
  String get callId;
  @override
  String get type;
  @override
  String get status;
  @override
  List<CallHistoryParticipantViewModel> get participants;
  @override
  DateTime get startDate;
  @override
  DateTime? get endDate;
  @override
  @JsonKey(ignore: true)
  _$$CallHistoryViewModelImplCopyWith<_$CallHistoryViewModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
