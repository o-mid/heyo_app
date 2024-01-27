// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_history_participant_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CallHistoryParticipantViewModel {
  String get name => throw _privateConstructorUsedError;
  String get coreId => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CallHistoryParticipantViewModelCopyWith<CallHistoryParticipantViewModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CallHistoryParticipantViewModelCopyWith<$Res> {
  factory $CallHistoryParticipantViewModelCopyWith(
          CallHistoryParticipantViewModel value,
          $Res Function(CallHistoryParticipantViewModel) then) =
      _$CallHistoryParticipantViewModelCopyWithImpl<$Res,
          CallHistoryParticipantViewModel>;
  @useResult
  $Res call(
      {String name,
      String coreId,
      DateTime startDate,
      DateTime? endDate,
      String status});
}

/// @nodoc
class _$CallHistoryParticipantViewModelCopyWithImpl<$Res,
        $Val extends CallHistoryParticipantViewModel>
    implements $CallHistoryParticipantViewModelCopyWith<$Res> {
  _$CallHistoryParticipantViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? coreId = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      coreId: null == coreId
          ? _value.coreId
          : coreId // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CallHistoryParticipantViewModelImplCopyWith<$Res>
    implements $CallHistoryParticipantViewModelCopyWith<$Res> {
  factory _$$CallHistoryParticipantViewModelImplCopyWith(
          _$CallHistoryParticipantViewModelImpl value,
          $Res Function(_$CallHistoryParticipantViewModelImpl) then) =
      __$$CallHistoryParticipantViewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String coreId,
      DateTime startDate,
      DateTime? endDate,
      String status});
}

/// @nodoc
class __$$CallHistoryParticipantViewModelImplCopyWithImpl<$Res>
    extends _$CallHistoryParticipantViewModelCopyWithImpl<$Res,
        _$CallHistoryParticipantViewModelImpl>
    implements _$$CallHistoryParticipantViewModelImplCopyWith<$Res> {
  __$$CallHistoryParticipantViewModelImplCopyWithImpl(
      _$CallHistoryParticipantViewModelImpl _value,
      $Res Function(_$CallHistoryParticipantViewModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? coreId = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? status = null,
  }) {
    return _then(_$CallHistoryParticipantViewModelImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      coreId: null == coreId
          ? _value.coreId
          : coreId // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CallHistoryParticipantViewModelImpl
    implements _CallHistoryParticipantViewModel {
  const _$CallHistoryParticipantViewModelImpl(
      {required this.name,
      required this.coreId,
      required this.startDate,
      this.endDate,
      this.status = 'calling'});

  @override
  final String name;
  @override
  final String coreId;
  @override
  final DateTime startDate;
  @override
  final DateTime? endDate;
  @override
  @JsonKey()
  final String status;

  @override
  String toString() {
    return 'CallHistoryParticipantViewModel(name: $name, coreId: $coreId, startDate: $startDate, endDate: $endDate, status: $status)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CallHistoryParticipantViewModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.coreId, coreId) || other.coreId == coreId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, name, coreId, startDate, endDate, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CallHistoryParticipantViewModelImplCopyWith<
          _$CallHistoryParticipantViewModelImpl>
      get copyWith => __$$CallHistoryParticipantViewModelImplCopyWithImpl<
          _$CallHistoryParticipantViewModelImpl>(this, _$identity);
}

abstract class _CallHistoryParticipantViewModel
    implements CallHistoryParticipantViewModel {
  const factory _CallHistoryParticipantViewModel(
      {required final String name,
      required final String coreId,
      required final DateTime startDate,
      final DateTime? endDate,
      final String status}) = _$CallHistoryParticipantViewModelImpl;

  @override
  String get name;
  @override
  String get coreId;
  @override
  DateTime get startDate;
  @override
  DateTime? get endDate;
  @override
  String get status;
  @override
  @JsonKey(ignore: true)
  _$$CallHistoryParticipantViewModelImplCopyWith<
          _$CallHistoryParticipantViewModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
