// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_history_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ChatHistoryDTO _$ChatHistoryDTOFromJson(Map<String, dynamic> json) {
  return _ChatHistoryDTO.fromJson(json);
}

/// @nodoc
mixin _$ChatHistoryDTO {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get lastMessage => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String get lastReadMessageId => throw _privateConstructorUsedError;
  List<MessagingParticipantModel> get participants =>
      throw _privateConstructorUsedError;
  int get notificationCount => throw _privateConstructorUsedError;
  String get scrollPosition => throw _privateConstructorUsedError;
  bool get isGroupChat => throw _privateConstructorUsedError;
  String get creatorCoreId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatHistoryDTOCopyWith<ChatHistoryDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatHistoryDTOCopyWith<$Res> {
  factory $ChatHistoryDTOCopyWith(
          ChatHistoryDTO value, $Res Function(ChatHistoryDTO) then) =
      _$ChatHistoryDTOCopyWithImpl<$Res, ChatHistoryDTO>;
  @useResult
  $Res call(
      {String id,
      String name,
      String lastMessage,
      DateTime timestamp,
      String lastReadMessageId,
      List<MessagingParticipantModel> participants,
      int notificationCount,
      String scrollPosition,
      bool isGroupChat,
      String creatorCoreId});
}

/// @nodoc
class _$ChatHistoryDTOCopyWithImpl<$Res, $Val extends ChatHistoryDTO>
    implements $ChatHistoryDTOCopyWith<$Res> {
  _$ChatHistoryDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? lastMessage = null,
    Object? timestamp = null,
    Object? lastReadMessageId = null,
    Object? participants = null,
    Object? notificationCount = null,
    Object? scrollPosition = null,
    Object? isGroupChat = null,
    Object? creatorCoreId = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessage: null == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastReadMessageId: null == lastReadMessageId
          ? _value.lastReadMessageId
          : lastReadMessageId // ignore: cast_nullable_to_non_nullable
              as String,
      participants: null == participants
          ? _value.participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<MessagingParticipantModel>,
      notificationCount: null == notificationCount
          ? _value.notificationCount
          : notificationCount // ignore: cast_nullable_to_non_nullable
              as int,
      scrollPosition: null == scrollPosition
          ? _value.scrollPosition
          : scrollPosition // ignore: cast_nullable_to_non_nullable
              as String,
      isGroupChat: null == isGroupChat
          ? _value.isGroupChat
          : isGroupChat // ignore: cast_nullable_to_non_nullable
              as bool,
      creatorCoreId: null == creatorCoreId
          ? _value.creatorCoreId
          : creatorCoreId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatHistoryDTOImplCopyWith<$Res>
    implements $ChatHistoryDTOCopyWith<$Res> {
  factory _$$ChatHistoryDTOImplCopyWith(_$ChatHistoryDTOImpl value,
          $Res Function(_$ChatHistoryDTOImpl) then) =
      __$$ChatHistoryDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String lastMessage,
      DateTime timestamp,
      String lastReadMessageId,
      List<MessagingParticipantModel> participants,
      int notificationCount,
      String scrollPosition,
      bool isGroupChat,
      String creatorCoreId});
}

/// @nodoc
class __$$ChatHistoryDTOImplCopyWithImpl<$Res>
    extends _$ChatHistoryDTOCopyWithImpl<$Res, _$ChatHistoryDTOImpl>
    implements _$$ChatHistoryDTOImplCopyWith<$Res> {
  __$$ChatHistoryDTOImplCopyWithImpl(
      _$ChatHistoryDTOImpl _value, $Res Function(_$ChatHistoryDTOImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? lastMessage = null,
    Object? timestamp = null,
    Object? lastReadMessageId = null,
    Object? participants = null,
    Object? notificationCount = null,
    Object? scrollPosition = null,
    Object? isGroupChat = null,
    Object? creatorCoreId = null,
  }) {
    return _then(_$ChatHistoryDTOImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessage: null == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastReadMessageId: null == lastReadMessageId
          ? _value.lastReadMessageId
          : lastReadMessageId // ignore: cast_nullable_to_non_nullable
              as String,
      participants: null == participants
          ? _value._participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<MessagingParticipantModel>,
      notificationCount: null == notificationCount
          ? _value.notificationCount
          : notificationCount // ignore: cast_nullable_to_non_nullable
              as int,
      scrollPosition: null == scrollPosition
          ? _value.scrollPosition
          : scrollPosition // ignore: cast_nullable_to_non_nullable
              as String,
      isGroupChat: null == isGroupChat
          ? _value.isGroupChat
          : isGroupChat // ignore: cast_nullable_to_non_nullable
              as bool,
      creatorCoreId: null == creatorCoreId
          ? _value.creatorCoreId
          : creatorCoreId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$ChatHistoryDTOImpl implements _ChatHistoryDTO {
  const _$ChatHistoryDTOImpl(
      {required this.id,
      required this.name,
      required this.lastMessage,
      required this.timestamp,
      required this.lastReadMessageId,
      required final List<MessagingParticipantModel> participants,
      this.notificationCount = 0,
      this.scrollPosition = '',
      this.isGroupChat = false,
      this.creatorCoreId = ''})
      : _participants = participants;

  factory _$ChatHistoryDTOImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatHistoryDTOImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String lastMessage;
  @override
  final DateTime timestamp;
  @override
  final String lastReadMessageId;
  final List<MessagingParticipantModel> _participants;
  @override
  List<MessagingParticipantModel> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  @override
  @JsonKey()
  final int notificationCount;
  @override
  @JsonKey()
  final String scrollPosition;
  @override
  @JsonKey()
  final bool isGroupChat;
  @override
  @JsonKey()
  final String creatorCoreId;

  @override
  String toString() {
    return 'ChatHistoryDTO(id: $id, name: $name, lastMessage: $lastMessage, timestamp: $timestamp, lastReadMessageId: $lastReadMessageId, participants: $participants, notificationCount: $notificationCount, scrollPosition: $scrollPosition, isGroupChat: $isGroupChat, creatorCoreId: $creatorCoreId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatHistoryDTOImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.lastReadMessageId, lastReadMessageId) ||
                other.lastReadMessageId == lastReadMessageId) &&
            const DeepCollectionEquality()
                .equals(other._participants, _participants) &&
            (identical(other.notificationCount, notificationCount) ||
                other.notificationCount == notificationCount) &&
            (identical(other.scrollPosition, scrollPosition) ||
                other.scrollPosition == scrollPosition) &&
            (identical(other.isGroupChat, isGroupChat) ||
                other.isGroupChat == isGroupChat) &&
            (identical(other.creatorCoreId, creatorCoreId) ||
                other.creatorCoreId == creatorCoreId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      lastMessage,
      timestamp,
      lastReadMessageId,
      const DeepCollectionEquality().hash(_participants),
      notificationCount,
      scrollPosition,
      isGroupChat,
      creatorCoreId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatHistoryDTOImplCopyWith<_$ChatHistoryDTOImpl> get copyWith =>
      __$$ChatHistoryDTOImplCopyWithImpl<_$ChatHistoryDTOImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatHistoryDTOImplToJson(
      this,
    );
  }
}

abstract class _ChatHistoryDTO implements ChatHistoryDTO {
  const factory _ChatHistoryDTO(
      {required final String id,
      required final String name,
      required final String lastMessage,
      required final DateTime timestamp,
      required final String lastReadMessageId,
      required final List<MessagingParticipantModel> participants,
      final int notificationCount,
      final String scrollPosition,
      final bool isGroupChat,
      final String creatorCoreId}) = _$ChatHistoryDTOImpl;

  factory _ChatHistoryDTO.fromJson(Map<String, dynamic> json) =
      _$ChatHistoryDTOImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get lastMessage;
  @override
  DateTime get timestamp;
  @override
  String get lastReadMessageId;
  @override
  List<MessagingParticipantModel> get participants;
  @override
  int get notificationCount;
  @override
  String get scrollPosition;
  @override
  bool get isGroupChat;
  @override
  String get creatorCoreId;
  @override
  @JsonKey(ignore: true)
  _$$ChatHistoryDTOImplCopyWith<_$ChatHistoryDTOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
