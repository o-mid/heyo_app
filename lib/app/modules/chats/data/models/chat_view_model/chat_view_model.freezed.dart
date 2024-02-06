// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ChatViewModel _$ChatViewModelFromJson(Map<String, dynamic> json) {
  return _ChatViewModel.fromJson(json);
}

/// @nodoc
mixin _$ChatViewModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get lastMessage => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  List<MessagingParticipantModel> get participants =>
      throw _privateConstructorUsedError;
  int get notificationCount => throw _privateConstructorUsedError;
  bool get isGroupChat => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatViewModelCopyWith<ChatViewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatViewModelCopyWith<$Res> {
  factory $ChatViewModelCopyWith(
          ChatViewModel value, $Res Function(ChatViewModel) then) =
      _$ChatViewModelCopyWithImpl<$Res, ChatViewModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String lastMessage,
      DateTime timestamp,
      List<MessagingParticipantModel> participants,
      int notificationCount,
      bool isGroupChat});
}

/// @nodoc
class _$ChatViewModelCopyWithImpl<$Res, $Val extends ChatViewModel>
    implements $ChatViewModelCopyWith<$Res> {
  _$ChatViewModelCopyWithImpl(this._value, this._then);

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
    Object? participants = null,
    Object? notificationCount = null,
    Object? isGroupChat = null,
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
      participants: null == participants
          ? _value.participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<MessagingParticipantModel>,
      notificationCount: null == notificationCount
          ? _value.notificationCount
          : notificationCount // ignore: cast_nullable_to_non_nullable
              as int,
      isGroupChat: null == isGroupChat
          ? _value.isGroupChat
          : isGroupChat // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatViewModelImplCopyWith<$Res>
    implements $ChatViewModelCopyWith<$Res> {
  factory _$$ChatViewModelImplCopyWith(
          _$ChatViewModelImpl value, $Res Function(_$ChatViewModelImpl) then) =
      __$$ChatViewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String lastMessage,
      DateTime timestamp,
      List<MessagingParticipantModel> participants,
      int notificationCount,
      bool isGroupChat});
}

/// @nodoc
class __$$ChatViewModelImplCopyWithImpl<$Res>
    extends _$ChatViewModelCopyWithImpl<$Res, _$ChatViewModelImpl>
    implements _$$ChatViewModelImplCopyWith<$Res> {
  __$$ChatViewModelImplCopyWithImpl(
      _$ChatViewModelImpl _value, $Res Function(_$ChatViewModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? lastMessage = null,
    Object? timestamp = null,
    Object? participants = null,
    Object? notificationCount = null,
    Object? isGroupChat = null,
  }) {
    return _then(_$ChatViewModelImpl(
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
      participants: null == participants
          ? _value._participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<MessagingParticipantModel>,
      notificationCount: null == notificationCount
          ? _value.notificationCount
          : notificationCount // ignore: cast_nullable_to_non_nullable
              as int,
      isGroupChat: null == isGroupChat
          ? _value.isGroupChat
          : isGroupChat // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$ChatViewModelImpl implements _ChatViewModel {
  const _$ChatViewModelImpl(
      {required this.id,
      required this.name,
      required this.lastMessage,
      required this.timestamp,
      required final List<MessagingParticipantModel> participants,
      this.notificationCount = 0,
      this.isGroupChat = false})
      : _participants = participants;

  factory _$ChatViewModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatViewModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String lastMessage;
  @override
  final DateTime timestamp;
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
  final bool isGroupChat;

  @override
  String toString() {
    return 'ChatViewModel(id: $id, name: $name, lastMessage: $lastMessage, timestamp: $timestamp, participants: $participants, notificationCount: $notificationCount, isGroupChat: $isGroupChat)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatViewModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality()
                .equals(other._participants, _participants) &&
            (identical(other.notificationCount, notificationCount) ||
                other.notificationCount == notificationCount) &&
            (identical(other.isGroupChat, isGroupChat) ||
                other.isGroupChat == isGroupChat));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      lastMessage,
      timestamp,
      const DeepCollectionEquality().hash(_participants),
      notificationCount,
      isGroupChat);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatViewModelImplCopyWith<_$ChatViewModelImpl> get copyWith =>
      __$$ChatViewModelImplCopyWithImpl<_$ChatViewModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatViewModelImplToJson(
      this,
    );
  }
}

abstract class _ChatViewModel implements ChatViewModel {
  const factory _ChatViewModel(
      {required final String id,
      required final String name,
      required final String lastMessage,
      required final DateTime timestamp,
      required final List<MessagingParticipantModel> participants,
      final int notificationCount,
      final bool isGroupChat}) = _$ChatViewModelImpl;

  factory _ChatViewModel.fromJson(Map<String, dynamic> json) =
      _$ChatViewModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get lastMessage;
  @override
  DateTime get timestamp;
  @override
  List<MessagingParticipantModel> get participants;
  @override
  int get notificationCount;
  @override
  bool get isGroupChat;
  @override
  @JsonKey(ignore: true)
  _$$ChatViewModelImplCopyWith<_$ChatViewModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
