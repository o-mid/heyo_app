// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatHistoryModelImpl _$$ChatHistoryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatHistoryModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      lastMessage: json['lastMessage'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      lastReadMessageId: json['lastReadMessageId'] as String,
      participants: (json['participants'] as List<dynamic>)
          .map((e) =>
              MessagingParticipantModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      notificationCount: json['notificationCount'] as int? ?? 0,
      scrollPosition: json['scrollPosition'] as String? ?? '',
      isGroupChat: json['isGroupChat'] as bool? ?? false,
      creatorCoreId: json['creatorCoreId'] as String? ?? '',
    );

Map<String, dynamic> _$$ChatHistoryModelImplToJson(
        _$ChatHistoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'lastMessage': instance.lastMessage,
      'timestamp': instance.timestamp.toIso8601String(),
      'lastReadMessageId': instance.lastReadMessageId,
      'participants': instance.participants.map((e) => e.toJson()).toList(),
      'notificationCount': instance.notificationCount,
      'scrollPosition': instance.scrollPosition,
      'isGroupChat': instance.isGroupChat,
      'creatorCoreId': instance.creatorCoreId,
    };
