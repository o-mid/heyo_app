// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_history_state_change_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CallHistoryStateChangeModel {
  String get callId => throw _privateConstructorUsedError;
  CallHistoryState get callHistoryState => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CallHistoryStateChangeModelCopyWith<CallHistoryStateChangeModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CallHistoryStateChangeModelCopyWith<$Res> {
  factory $CallHistoryStateChangeModelCopyWith(
          CallHistoryStateChangeModel value,
          $Res Function(CallHistoryStateChangeModel) then) =
      _$CallHistoryStateChangeModelCopyWithImpl<$Res,
          CallHistoryStateChangeModel>;
  @useResult
  $Res call({String callId, CallHistoryState callHistoryState});
}

/// @nodoc
class _$CallHistoryStateChangeModelCopyWithImpl<$Res,
        $Val extends CallHistoryStateChangeModel>
    implements $CallHistoryStateChangeModelCopyWith<$Res> {
  _$CallHistoryStateChangeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callId = null,
    Object? callHistoryState = null,
  }) {
    return _then(_value.copyWith(
      callId: null == callId
          ? _value.callId
          : callId // ignore: cast_nullable_to_non_nullable
              as String,
      callHistoryState: null == callHistoryState
          ? _value.callHistoryState
          : callHistoryState // ignore: cast_nullable_to_non_nullable
              as CallHistoryState,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CallHistoryStateChangeModelImplCopyWith<$Res>
    implements $CallHistoryStateChangeModelCopyWith<$Res> {
  factory _$$CallHistoryStateChangeModelImplCopyWith(
          _$CallHistoryStateChangeModelImpl value,
          $Res Function(_$CallHistoryStateChangeModelImpl) then) =
      __$$CallHistoryStateChangeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String callId, CallHistoryState callHistoryState});
}

/// @nodoc
class __$$CallHistoryStateChangeModelImplCopyWithImpl<$Res>
    extends _$CallHistoryStateChangeModelCopyWithImpl<$Res,
        _$CallHistoryStateChangeModelImpl>
    implements _$$CallHistoryStateChangeModelImplCopyWith<$Res> {
  __$$CallHistoryStateChangeModelImplCopyWithImpl(
      _$CallHistoryStateChangeModelImpl _value,
      $Res Function(_$CallHistoryStateChangeModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callId = null,
    Object? callHistoryState = null,
  }) {
    return _then(_$CallHistoryStateChangeModelImpl(
      callId: null == callId
          ? _value.callId
          : callId // ignore: cast_nullable_to_non_nullable
              as String,
      callHistoryState: null == callHistoryState
          ? _value.callHistoryState
          : callHistoryState // ignore: cast_nullable_to_non_nullable
              as CallHistoryState,
    ));
  }
}

/// @nodoc

class _$CallHistoryStateChangeModelImpl
    implements _CallHistoryStateChangeModel {
  const _$CallHistoryStateChangeModelImpl(
      {required this.callId, required this.callHistoryState});

  @override
  final String callId;
  @override
  final CallHistoryState callHistoryState;

  @override
  String toString() {
    return 'CallHistoryStateChangeModel(callId: $callId, callHistoryState: $callHistoryState)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CallHistoryStateChangeModelImpl &&
            (identical(other.callId, callId) || other.callId == callId) &&
            (identical(other.callHistoryState, callHistoryState) ||
                other.callHistoryState == callHistoryState));
  }

  @override
  int get hashCode => Object.hash(runtimeType, callId, callHistoryState);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CallHistoryStateChangeModelImplCopyWith<_$CallHistoryStateChangeModelImpl>
      get copyWith => __$$CallHistoryStateChangeModelImplCopyWithImpl<
          _$CallHistoryStateChangeModelImpl>(this, _$identity);
}

abstract class _CallHistoryStateChangeModel
    implements CallHistoryStateChangeModel {
  const factory _CallHistoryStateChangeModel(
          {required final String callId,
          required final CallHistoryState callHistoryState}) =
      _$CallHistoryStateChangeModelImpl;

  @override
  String get callId;
  @override
  CallHistoryState get callHistoryState;
  @override
  @JsonKey(ignore: true)
  _$$CallHistoryStateChangeModelImplCopyWith<_$CallHistoryStateChangeModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
