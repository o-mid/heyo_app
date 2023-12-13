// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connected_participant_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ConnectedParticipantModel {
  String get name => throw _privateConstructorUsedError;
  String get coreId =>
      throw _privateConstructorUsedError; //@RxBoolConverter() required bool audioMode,
//@RxBoolConverter() required bool videoMode,
  RxBool get audioMode => throw _privateConstructorUsedError;
  RxBool get videoMode => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  MediaStream? get stream => throw _privateConstructorUsedError;
  RTCVideoRenderer? get rtcVideoRenderer => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ConnectedParticipantModelCopyWith<ConnectedParticipantModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConnectedParticipantModelCopyWith<$Res> {
  factory $ConnectedParticipantModelCopyWith(ConnectedParticipantModel value,
          $Res Function(ConnectedParticipantModel) then) =
      _$ConnectedParticipantModelCopyWithImpl<$Res, ConnectedParticipantModel>;
  @useResult
  $Res call(
      {String name,
      String coreId,
      RxBool audioMode,
      RxBool videoMode,
      String status,
      MediaStream? stream,
      RTCVideoRenderer? rtcVideoRenderer});
}

/// @nodoc
class _$ConnectedParticipantModelCopyWithImpl<$Res,
        $Val extends ConnectedParticipantModel>
    implements $ConnectedParticipantModelCopyWith<$Res> {
  _$ConnectedParticipantModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? coreId = null,
    Object? audioMode = null,
    Object? videoMode = null,
    Object? status = null,
    Object? stream = freezed,
    Object? rtcVideoRenderer = freezed,
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
      audioMode: null == audioMode
          ? _value.audioMode
          : audioMode // ignore: cast_nullable_to_non_nullable
              as RxBool,
      videoMode: null == videoMode
          ? _value.videoMode
          : videoMode // ignore: cast_nullable_to_non_nullable
              as RxBool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      stream: freezed == stream
          ? _value.stream
          : stream // ignore: cast_nullable_to_non_nullable
              as MediaStream?,
      rtcVideoRenderer: freezed == rtcVideoRenderer
          ? _value.rtcVideoRenderer
          : rtcVideoRenderer // ignore: cast_nullable_to_non_nullable
              as RTCVideoRenderer?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConnectedParticipantModelImplCopyWith<$Res>
    implements $ConnectedParticipantModelCopyWith<$Res> {
  factory _$$ConnectedParticipantModelImplCopyWith(
          _$ConnectedParticipantModelImpl value,
          $Res Function(_$ConnectedParticipantModelImpl) then) =
      __$$ConnectedParticipantModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String coreId,
      RxBool audioMode,
      RxBool videoMode,
      String status,
      MediaStream? stream,
      RTCVideoRenderer? rtcVideoRenderer});
}

/// @nodoc
class __$$ConnectedParticipantModelImplCopyWithImpl<$Res>
    extends _$ConnectedParticipantModelCopyWithImpl<$Res,
        _$ConnectedParticipantModelImpl>
    implements _$$ConnectedParticipantModelImplCopyWith<$Res> {
  __$$ConnectedParticipantModelImplCopyWithImpl(
      _$ConnectedParticipantModelImpl _value,
      $Res Function(_$ConnectedParticipantModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? coreId = null,
    Object? audioMode = null,
    Object? videoMode = null,
    Object? status = null,
    Object? stream = freezed,
    Object? rtcVideoRenderer = freezed,
  }) {
    return _then(_$ConnectedParticipantModelImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      coreId: null == coreId
          ? _value.coreId
          : coreId // ignore: cast_nullable_to_non_nullable
              as String,
      audioMode: null == audioMode
          ? _value.audioMode
          : audioMode // ignore: cast_nullable_to_non_nullable
              as RxBool,
      videoMode: null == videoMode
          ? _value.videoMode
          : videoMode // ignore: cast_nullable_to_non_nullable
              as RxBool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      stream: freezed == stream
          ? _value.stream
          : stream // ignore: cast_nullable_to_non_nullable
              as MediaStream?,
      rtcVideoRenderer: freezed == rtcVideoRenderer
          ? _value.rtcVideoRenderer
          : rtcVideoRenderer // ignore: cast_nullable_to_non_nullable
              as RTCVideoRenderer?,
    ));
  }
}

/// @nodoc

class _$ConnectedParticipantModelImpl implements _ConnectedParticipantModel {
  const _$ConnectedParticipantModelImpl(
      {required this.name,
      required this.coreId,
      required this.audioMode,
      required this.videoMode,
      this.status = 'connected',
      this.stream,
      this.rtcVideoRenderer});

  @override
  final String name;
  @override
  final String coreId;
//@RxBoolConverter() required bool audioMode,
//@RxBoolConverter() required bool videoMode,
  @override
  final RxBool audioMode;
  @override
  final RxBool videoMode;
  @override
  @JsonKey()
  final String status;
  @override
  final MediaStream? stream;
  @override
  final RTCVideoRenderer? rtcVideoRenderer;

  @override
  String toString() {
    return 'ConnectedParticipantModel(name: $name, coreId: $coreId, audioMode: $audioMode, videoMode: $videoMode, status: $status, stream: $stream, rtcVideoRenderer: $rtcVideoRenderer)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectedParticipantModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.coreId, coreId) || other.coreId == coreId) &&
            (identical(other.audioMode, audioMode) ||
                other.audioMode == audioMode) &&
            (identical(other.videoMode, videoMode) ||
                other.videoMode == videoMode) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.stream, stream) || other.stream == stream) &&
            (identical(other.rtcVideoRenderer, rtcVideoRenderer) ||
                other.rtcVideoRenderer == rtcVideoRenderer));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, coreId, audioMode,
      videoMode, status, stream, rtcVideoRenderer);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectedParticipantModelImplCopyWith<_$ConnectedParticipantModelImpl>
      get copyWith => __$$ConnectedParticipantModelImplCopyWithImpl<
          _$ConnectedParticipantModelImpl>(this, _$identity);
}

abstract class _ConnectedParticipantModel implements ConnectedParticipantModel {
  const factory _ConnectedParticipantModel(
          {required final String name,
          required final String coreId,
          required final RxBool audioMode,
          required final RxBool videoMode,
          final String status,
          final MediaStream? stream,
          final RTCVideoRenderer? rtcVideoRenderer}) =
      _$ConnectedParticipantModelImpl;

  @override
  String get name;
  @override
  String get coreId;
  @override //@RxBoolConverter() required bool audioMode,
//@RxBoolConverter() required bool videoMode,
  RxBool get audioMode;
  @override
  RxBool get videoMode;
  @override
  String get status;
  @override
  MediaStream? get stream;
  @override
  RTCVideoRenderer? get rtcVideoRenderer;
  @override
  @JsonKey(ignore: true)
  _$$ConnectedParticipantModelImplCopyWith<_$ConnectedParticipantModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
