// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_participant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AllParticipantModelImpl _$$AllParticipantModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AllParticipantModelImpl(
      name: json['name'] as String,
      iconUrl: json['iconUrl'] as String,
      coreId: json['coreId'] as String,
      status:
          $enumDecodeNullable(_$AllParticipantStatusEnumMap, json['status']) ??
              AllParticipantStatus.calling,
    );

Map<String, dynamic> _$$AllParticipantModelImplToJson(
        _$AllParticipantModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'iconUrl': instance.iconUrl,
      'coreId': instance.coreId,
      'status': _$AllParticipantStatusEnumMap[instance.status]!,
    };

const _$AllParticipantStatusEnumMap = {
  AllParticipantStatus.calling: 'calling',
  AllParticipantStatus.rejected: 'rejected',
  AllParticipantStatus.accepted: 'accepted',
};
