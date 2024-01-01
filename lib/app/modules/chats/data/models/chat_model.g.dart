// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatModelImpl _$$ChatModelImplFromJson(Map<String, dynamic> json) =>
    _$ChatModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      lastMessage: json['lastMessage'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isOnline: json['isOnline'] as bool? ?? false,
      isVerified: json['isVerified'] as bool? ?? false,
      notificationCount: json['notificationCount'] as int? ?? 0,
      scrollPosition: json['scrollPosition'] as String? ?? '',
      lastReadMessageId: json['lastReadMessageId'] as String,
      participants: (json['participants'] as List<dynamic>)
          .map((e) =>
              MessagingParticipantModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ChatModelImplToJson(_$ChatModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'lastMessage': instance.lastMessage,
      'timestamp': instance.timestamp.toIso8601String(),
      'isOnline': instance.isOnline,
      'isVerified': instance.isVerified,
      'notificationCount': instance.notificationCount,
      'scrollPosition': instance.scrollPosition,
      'lastReadMessageId': instance.lastReadMessageId,
      'participants': instance.participants.map((e) => e.toJson()).toList(),
    };
