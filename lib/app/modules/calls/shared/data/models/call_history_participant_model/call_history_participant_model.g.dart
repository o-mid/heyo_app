// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_history_participant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CallHistoryParticipantModelImpl _$$CallHistoryParticipantModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CallHistoryParticipantModelImpl(
      name: json['name'] as String,
      coreId: json['coreId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      status: $enumDecodeNullable(
              _$CallHistoryParticipantStatusEnumMap, json['status']) ??
          CallHistoryParticipantStatus.calling,
    );

Map<String, dynamic> _$$CallHistoryParticipantModelImplToJson(
        _$CallHistoryParticipantModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'coreId': instance.coreId,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'status': _$CallHistoryParticipantStatusEnumMap[instance.status]!,
    };

const _$CallHistoryParticipantStatusEnumMap = {
  CallHistoryParticipantStatus.calling: 'calling',
  CallHistoryParticipantStatus.rejected: 'rejected',
  CallHistoryParticipantStatus.accepted: 'accepted',
};
