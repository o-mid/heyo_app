// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_view_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatViewModelImpl _$$ChatViewModelImplFromJson(Map<String, dynamic> json) =>
    _$ChatViewModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      lastMessage: json['lastMessage'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      participantsIds: (json['participantsIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      notificationCount: json['notificationCount'] as int? ?? 0,
      isGroupChat: json['isGroupChat'] as bool? ?? false,
    );

Map<String, dynamic> _$$ChatViewModelImplToJson(_$ChatViewModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'lastMessage': instance.lastMessage,
      'timestamp': instance.timestamp.toIso8601String(),
      'participantsIds': instance.participantsIds,
      'notificationCount': instance.notificationCount,
      'isGroupChat': instance.isGroupChat,
    };
