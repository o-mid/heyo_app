// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_history_detail_participant_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CallHistoryDetailParticipantModel {
  String get name => throw _privateConstructorUsedError;
  String get coreId => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CallHistoryDetailParticipantModelCopyWith<CallHistoryDetailParticipantModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CallHistoryDetailParticipantModelCopyWith<$Res> {
  factory $CallHistoryDetailParticipantModelCopyWith(
          CallHistoryDetailParticipantModel value,
          $Res Function(CallHistoryDetailParticipantModel) then) =
      _$CallHistoryDetailParticipantModelCopyWithImpl<$Res,
          CallHistoryDetailParticipantModel>;
  @useResult
  $Res call(
      {String name, String coreId, DateTime startDate, DateTime? endDate});
}

/// @nodoc
class _$CallHistoryDetailParticipantModelCopyWithImpl<$Res,
        $Val extends CallHistoryDetailParticipantModel>
    implements $CallHistoryDetailParticipantModelCopyWith<$Res> {
  _$CallHistoryDetailParticipantModelCopyWithImpl(this._value, this._then);

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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CallHistoryDetailParticipantModelImplCopyWith<$Res>
    implements $CallHistoryDetailParticipantModelCopyWith<$Res> {
  factory _$$CallHistoryDetailParticipantModelImplCopyWith(
          _$CallHistoryDetailParticipantModelImpl value,
          $Res Function(_$CallHistoryDetailParticipantModelImpl) then) =
      __$$CallHistoryDetailParticipantModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name, String coreId, DateTime startDate, DateTime? endDate});
}

/// @nodoc
class __$$CallHistoryDetailParticipantModelImplCopyWithImpl<$Res>
    extends _$CallHistoryDetailParticipantModelCopyWithImpl<$Res,
        _$CallHistoryDetailParticipantModelImpl>
    implements _$$CallHistoryDetailParticipantModelImplCopyWith<$Res> {
  __$$CallHistoryDetailParticipantModelImplCopyWithImpl(
      _$CallHistoryDetailParticipantModelImpl _value,
      $Res Function(_$CallHistoryDetailParticipantModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? coreId = null,
    Object? startDate = null,
    Object? endDate = freezed,
  }) {
    return _then(_$CallHistoryDetailParticipantModelImpl(
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
    ));
  }
}

/// @nodoc

class _$CallHistoryDetailParticipantModelImpl
    implements _CallHistoryDetailParticipantModel {
  const _$CallHistoryDetailParticipantModelImpl(
      {required this.name,
      required this.coreId,
      required this.startDate,
      this.endDate});

  @override
  final String name;
  @override
  final String coreId;
  @override
  final DateTime startDate;
  @override
  final DateTime? endDate;

  @override
  String toString() {
    return 'CallHistoryDetailParticipantModel(name: $name, coreId: $coreId, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CallHistoryDetailParticipantModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.coreId, coreId) || other.coreId == coreId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, name, coreId, startDate, endDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CallHistoryDetailParticipantModelImplCopyWith<
          _$CallHistoryDetailParticipantModelImpl>
      get copyWith => __$$CallHistoryDetailParticipantModelImplCopyWithImpl<
          _$CallHistoryDetailParticipantModelImpl>(this, _$identity);
}

abstract class _CallHistoryDetailParticipantModel
    implements CallHistoryDetailParticipantModel {
  const factory _CallHistoryDetailParticipantModel(
      {required final String name,
      required final String coreId,
      required final DateTime startDate,
      final DateTime? endDate}) = _$CallHistoryDetailParticipantModelImpl;

  @override
  String get name;
  @override
  String get coreId;
  @override
  DateTime get startDate;
  @override
  DateTime? get endDate;
  @override
  @JsonKey(ignore: true)
  _$$CallHistoryDetailParticipantModelImplCopyWith<
          _$CallHistoryDetailParticipantModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
