// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CallHistoryModelImpl _$$CallHistoryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CallHistoryModelImpl(
      callId: json['callId'] as String,
      type: $enumDecode(_$CallTypeEnumMap, json['type']),
      status: $enumDecode(_$CallStatusEnumMap, json['status']),
      participants: (json['participants'] as List<dynamic>)
          .map((e) =>
              CallHistoryParticipantModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$$CallHistoryModelImplToJson(
        _$CallHistoryModelImpl instance) =>
    <String, dynamic>{
      'callId': instance.callId,
      'type': _$CallTypeEnumMap[instance.type]!,
      'status': _$CallStatusEnumMap[instance.status]!,
      'participants': instance.participants.map((e) => e.toJson()).toList(),
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
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
