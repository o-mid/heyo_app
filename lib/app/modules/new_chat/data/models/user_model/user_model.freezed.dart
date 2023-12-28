// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get coreId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get iconUrl => throw _privateConstructorUsedError;
  String get walletAddress => throw _privateConstructorUsedError;
  String get nickname => throw _privateConstructorUsedError;
  bool get isOnline => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  bool get isBlocked => throw _privateConstructorUsedError;
  bool get isContact => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {String coreId,
      String name,
      String? iconUrl,
      String walletAddress,
      String nickname,
      bool isOnline,
      bool isVerified,
      bool isBlocked,
      bool isContact});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coreId = null,
    Object? name = null,
    Object? iconUrl = freezed,
    Object? walletAddress = null,
    Object? nickname = null,
    Object? isOnline = null,
    Object? isVerified = null,
    Object? isBlocked = null,
    Object? isContact = null,
  }) {
    return _then(_value.copyWith(
      coreId: null == coreId
          ? _value.coreId
          : coreId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      walletAddress: null == walletAddress
          ? _value.walletAddress
          : walletAddress // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isBlocked: null == isBlocked
          ? _value.isBlocked
          : isBlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      isContact: null == isContact
          ? _value.isContact
          : isContact // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String coreId,
      String name,
      String? iconUrl,
      String walletAddress,
      String nickname,
      bool isOnline,
      bool isVerified,
      bool isBlocked,
      bool isContact});
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coreId = null,
    Object? name = null,
    Object? iconUrl = freezed,
    Object? walletAddress = null,
    Object? nickname = null,
    Object? isOnline = null,
    Object? isVerified = null,
    Object? isBlocked = null,
    Object? isContact = null,
  }) {
    return _then(_$UserModelImpl(
      coreId: null == coreId
          ? _value.coreId
          : coreId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      walletAddress: null == walletAddress
          ? _value.walletAddress
          : walletAddress // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isBlocked: null == isBlocked
          ? _value.isBlocked
          : isBlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      isContact: null == isContact
          ? _value.isContact
          : isContact // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl(
      {required this.coreId,
      required this.name,
      required this.iconUrl,
      required this.walletAddress,
      this.nickname = '',
      this.isOnline = false,
      this.isVerified = false,
      this.isBlocked = false,
      this.isContact = false});

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String coreId;
  @override
  final String name;
  @override
  final String? iconUrl;
  @override
  final String walletAddress;
  @override
  @JsonKey()
  final String nickname;
  @override
  @JsonKey()
  final bool isOnline;
  @override
  @JsonKey()
  final bool isVerified;
  @override
  @JsonKey()
  final bool isBlocked;
  @override
  @JsonKey()
  final bool isContact;

  @override
  String toString() {
    return 'UserModel(coreId: $coreId, name: $name, iconUrl: $iconUrl, walletAddress: $walletAddress, nickname: $nickname, isOnline: $isOnline, isVerified: $isVerified, isBlocked: $isBlocked, isContact: $isContact)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.coreId, coreId) || other.coreId == coreId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.walletAddress, walletAddress) ||
                other.walletAddress == walletAddress) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.isBlocked, isBlocked) ||
                other.isBlocked == isBlocked) &&
            (identical(other.isContact, isContact) ||
                other.isContact == isContact));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, coreId, name, iconUrl,
      walletAddress, nickname, isOnline, isVerified, isBlocked, isContact);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel(
      {required final String coreId,
      required final String name,
      required final String? iconUrl,
      required final String walletAddress,
      final String nickname,
      final bool isOnline,
      final bool isVerified,
      final bool isBlocked,
      final bool isContact}) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get coreId;
  @override
  String get name;
  @override
  String? get iconUrl;
  @override
  String get walletAddress;
  @override
  String get nickname;
  @override
  bool get isOnline;
  @override
  bool get isVerified;
  @override
  bool get isBlocked;
  @override
  bool get isContact;
  @override
  @JsonKey(ignore: true)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
