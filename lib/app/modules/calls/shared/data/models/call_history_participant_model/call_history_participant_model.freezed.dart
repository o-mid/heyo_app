// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_history_participant_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CallHistoryParticipantModel _$CallHistoryParticipantModelFromJson(
    Map<String, dynamic> json) {
  return _CallHistoryParticipantModel.fromJson(json);
}

/// @nodoc
mixin _$CallHistoryParticipantModel {
  String get name => throw _privateConstructorUsedError;
  String get iconUrl => throw _privateConstructorUsedError;
  String get coreId => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  CallHistoryParticipantStatus get status => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CallHistoryParticipantModelCopyWith<CallHistoryParticipantModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CallHistoryParticipantModelCopyWith<$Res> {
  factory $CallHistoryParticipantModelCopyWith(
          CallHistoryParticipantModel value,
          $Res Function(CallHistoryParticipantModel) then) =
      _$CallHistoryParticipantModelCopyWithImpl<$Res,
          CallHistoryParticipantModel>;
  @useResult
  $Res call(
      {String name,
      String iconUrl,
      String coreId,
      DateTime startDate,
      DateTime? endDate,
      CallHistoryParticipantStatus status});
}

/// @nodoc
class _$CallHistoryParticipantModelCopyWithImpl<$Res,
        $Val extends CallHistoryParticipantModel>
    implements $CallHistoryParticipantModelCopyWith<$Res> {
  _$CallHistoryParticipantModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? iconUrl = null,
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
      iconUrl: null == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
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
              as CallHistoryParticipantStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CallHistoryParticipantModelImplCopyWith<$Res>
    implements $CallHistoryParticipantModelCopyWith<$Res> {
  factory _$$CallHistoryParticipantModelImplCopyWith(
          _$CallHistoryParticipantModelImpl value,
          $Res Function(_$CallHistoryParticipantModelImpl) then) =
      __$$CallHistoryParticipantModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String iconUrl,
      String coreId,
      DateTime startDate,
      DateTime? endDate,
      CallHistoryParticipantStatus status});
}

/// @nodoc
class __$$CallHistoryParticipantModelImplCopyWithImpl<$Res>
    extends _$CallHistoryParticipantModelCopyWithImpl<$Res,
        _$CallHistoryParticipantModelImpl>
    implements _$$CallHistoryParticipantModelImplCopyWith<$Res> {
  __$$CallHistoryParticipantModelImplCopyWithImpl(
      _$CallHistoryParticipantModelImpl _value,
      $Res Function(_$CallHistoryParticipantModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? iconUrl = null,
    Object? coreId = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? status = null,
  }) {
    return _then(_$CallHistoryParticipantModelImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      iconUrl: null == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
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
              as CallHistoryParticipantStatus,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$CallHistoryParticipantModelImpl
    implements _CallHistoryParticipantModel {
  const _$CallHistoryParticipantModelImpl(
      {required this.name,
      required this.iconUrl,
      required this.coreId,
      required this.startDate,
      this.endDate,
      this.status = CallHistoryParticipantStatus.calling});

  factory _$CallHistoryParticipantModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$CallHistoryParticipantModelImplFromJson(json);

  @override
  final String name;
  @override
  final String iconUrl;
  @override
  final String coreId;
  @override
  final DateTime startDate;
  @override
  final DateTime? endDate;
  @override
  @JsonKey()
  final CallHistoryParticipantStatus status;

  @override
  String toString() {
    return 'CallHistoryParticipantModel(name: $name, iconUrl: $iconUrl, coreId: $coreId, startDate: $startDate, endDate: $endDate, status: $status)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CallHistoryParticipantModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.coreId, coreId) || other.coreId == coreId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, iconUrl, coreId, startDate, endDate, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CallHistoryParticipantModelImplCopyWith<_$CallHistoryParticipantModelImpl>
      get copyWith => __$$CallHistoryParticipantModelImplCopyWithImpl<
          _$CallHistoryParticipantModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CallHistoryParticipantModelImplToJson(
      this,
    );
  }
}

abstract class _CallHistoryParticipantModel
    implements CallHistoryParticipantModel {
  const factory _CallHistoryParticipantModel(
          {required final String name,
          required final String iconUrl,
          required final String coreId,
          required final DateTime startDate,
          final DateTime? endDate,
          final CallHistoryParticipantStatus status}) =
      _$CallHistoryParticipantModelImpl;

  factory _CallHistoryParticipantModel.fromJson(Map<String, dynamic> json) =
      _$CallHistoryParticipantModelImpl.fromJson;

  @override
  String get name;
  @override
  String get iconUrl;
  @override
  String get coreId;
  @override
  DateTime get startDate;
  @override
  DateTime? get endDate;
  @override
  CallHistoryParticipantStatus get status;
  @override
  @JsonKey(ignore: true)
  _$$CallHistoryParticipantModelImplCopyWith<_$CallHistoryParticipantModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
