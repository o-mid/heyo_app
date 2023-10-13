// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CallHistoryModelImpl _$$CallHistoryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CallHistoryModelImpl(
      id: json['id'] as String,
      coreId: json['coreId'] as String,
      type: $enumDecode(_$CallTypeEnumMap, json['type']),
      status: $enumDecode(_$CallStatusEnumMap, json['status']),
      participants: (json['participants'] as List<dynamic>)
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      date: DateTime.parse(json['date'] as String),
      dataUsageMB: (json['dataUsageMB'] as num?)?.toDouble() ?? 0,
      duration: json['duration'] == null
          ? Duration.zero
          : Duration(microseconds: json['duration'] as int),
    );

Map<String, dynamic> _$$CallHistoryModelImplToJson(
        _$CallHistoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'coreId': instance.coreId,
      'type': _$CallTypeEnumMap[instance.type]!,
      'status': _$CallStatusEnumMap[instance.status]!,
      'participants': instance.participants.map((e) => e.toJson()).toList(),
      'date': instance.date.toIso8601String(),
      'dataUsageMB': instance.dataUsageMB,
      'duration': instance.duration.inMicroseconds,
    };

const _$CallTypeEnumMap = {
  CallType.audio: 'audio',
  CallType.video: 'video',
};

const _$CallStatusEnumMap = {
  CallStatus.incomingMissed: 'incomingMissed',
  CallStatus.incomingAnswered: 'incomingAnswered',
  CallStatus.incomingDeclined: 'incomingDeclined',
  CallStatus.outgoingNotAnswered: 'outgoingNotAnswered',
  CallStatus.outgoingCanceled: 'outgoingCanceled',
  CallStatus.outgoingDeclined: 'outgoingDeclined',
  CallStatus.outgoingAnswered: 'outgoingAnswered',
};
