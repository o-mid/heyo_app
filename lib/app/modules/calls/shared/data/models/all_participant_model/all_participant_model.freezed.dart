// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'all_participant_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AllParticipantModel {
  String get name => throw _privateConstructorUsedError;
  String get iconUrl => throw _privateConstructorUsedError;
  String get coreId => throw _privateConstructorUsedError;
  AllParticipantStatus get status => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AllParticipantModelCopyWith<AllParticipantModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AllParticipantModelCopyWith<$Res> {
  factory $AllParticipantModelCopyWith(
          AllParticipantModel value, $Res Function(AllParticipantModel) then) =
      _$AllParticipantModelCopyWithImpl<$Res, AllParticipantModel>;
  @useResult
  $Res call(
      {String name,
      String iconUrl,
      String coreId,
      AllParticipantStatus status});
}

/// @nodoc
class _$AllParticipantModelCopyWithImpl<$Res, $Val extends AllParticipantModel>
    implements $AllParticipantModelCopyWith<$Res> {
  _$AllParticipantModelCopyWithImpl(this._value, this._then);

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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AllParticipantStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AllParticipantModelImplCopyWith<$Res>
    implements $AllParticipantModelCopyWith<$Res> {
  factory _$$AllParticipantModelImplCopyWith(_$AllParticipantModelImpl value,
          $Res Function(_$AllParticipantModelImpl) then) =
      __$$AllParticipantModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String iconUrl,
      String coreId,
      AllParticipantStatus status});
}

/// @nodoc
class __$$AllParticipantModelImplCopyWithImpl<$Res>
    extends _$AllParticipantModelCopyWithImpl<$Res, _$AllParticipantModelImpl>
    implements _$$AllParticipantModelImplCopyWith<$Res> {
  __$$AllParticipantModelImplCopyWithImpl(_$AllParticipantModelImpl _value,
      $Res Function(_$AllParticipantModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? iconUrl = null,
    Object? coreId = null,
    Object? status = null,
  }) {
    return _then(_$AllParticipantModelImpl(
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AllParticipantStatus,
    ));
  }
}

/// @nodoc

class _$AllParticipantModelImpl implements _AllParticipantModel {
  const _$AllParticipantModelImpl(
      {required this.name,
      required this.iconUrl,
      required this.coreId,
      this.status = AllParticipantStatus.calling});

  @override
  final String name;
  @override
  final String iconUrl;
  @override
  final String coreId;
  @override
  @JsonKey()
  final AllParticipantStatus status;

  @override
  String toString() {
    return 'AllParticipantModel(name: $name, iconUrl: $iconUrl, coreId: $coreId, status: $status)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AllParticipantModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.coreId, coreId) || other.coreId == coreId) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, iconUrl, coreId, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AllParticipantModelImplCopyWith<_$AllParticipantModelImpl> get copyWith =>
      __$$AllParticipantModelImplCopyWithImpl<_$AllParticipantModelImpl>(
          this, _$identity);
}

abstract class _AllParticipantModel implements AllParticipantModel {
  const factory _AllParticipantModel(
      {required final String name,
      required final String iconUrl,
      required final String coreId,
      final AllParticipantStatus status}) = _$AllParticipantModelImpl;

  @override
  String get name;
  @override
  String get iconUrl;
  @override
  String get coreId;
  @override
  AllParticipantStatus get status;
  @override
  @JsonKey(ignore: true)
  _$$AllParticipantModelImplCopyWith<_$AllParticipantModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
