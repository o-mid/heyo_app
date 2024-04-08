// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ContactDTO _$ContactDTOFromJson(Map<String, dynamic> json) {
  return _ContactDTO.fromJson(json);
}

/// @nodoc
mixin _$ContactDTO {
  String get coreId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContactDTOCopyWith<ContactDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactDTOCopyWith<$Res> {
  factory $ContactDTOCopyWith(
          ContactDTO value, $Res Function(ContactDTO) then) =
      _$ContactDTOCopyWithImpl<$Res, ContactDTO>;
  @useResult
  $Res call({String coreId, String name});
}

/// @nodoc
class _$ContactDTOCopyWithImpl<$Res, $Val extends ContactDTO>
    implements $ContactDTOCopyWith<$Res> {
  _$ContactDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coreId = null,
    Object? name = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContactDTOImplCopyWith<$Res>
    implements $ContactDTOCopyWith<$Res> {
  factory _$$ContactDTOImplCopyWith(
          _$ContactDTOImpl value, $Res Function(_$ContactDTOImpl) then) =
      __$$ContactDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String coreId, String name});
}

/// @nodoc
class __$$ContactDTOImplCopyWithImpl<$Res>
    extends _$ContactDTOCopyWithImpl<$Res, _$ContactDTOImpl>
    implements _$$ContactDTOImplCopyWith<$Res> {
  __$$ContactDTOImplCopyWithImpl(
      _$ContactDTOImpl _value, $Res Function(_$ContactDTOImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coreId = null,
    Object? name = null,
  }) {
    return _then(_$ContactDTOImpl(
      coreId: null == coreId
          ? _value.coreId
          : coreId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$ContactDTOImpl implements _ContactDTO {
  const _$ContactDTOImpl({required this.coreId, required this.name});

  factory _$ContactDTOImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactDTOImplFromJson(json);

  @override
  final String coreId;
  @override
  final String name;

  @override
  String toString() {
    return 'ContactDTO(coreId: $coreId, name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactDTOImpl &&
            (identical(other.coreId, coreId) || other.coreId == coreId) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, coreId, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactDTOImplCopyWith<_$ContactDTOImpl> get copyWith =>
      __$$ContactDTOImplCopyWithImpl<_$ContactDTOImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactDTOImplToJson(
      this,
    );
  }
}

abstract class _ContactDTO implements ContactDTO {
  const factory _ContactDTO(
      {required final String coreId,
      required final String name}) = _$ContactDTOImpl;

  factory _ContactDTO.fromJson(Map<String, dynamic> json) =
      _$ContactDTOImpl.fromJson;

  @override
  String get coreId;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$ContactDTOImplCopyWith<_$ContactDTOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
