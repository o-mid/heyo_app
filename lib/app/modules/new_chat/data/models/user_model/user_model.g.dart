// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      coreId: json['coreId'] as String,
      name: json['name'] as String,
      iconUrl: json['iconUrl'] as String,
      walletAddress: json['walletAddress'] as String,
      nickname: json['nickname'] as String? ?? '',
      isOnline: json['isOnline'] as bool? ?? false,
      isVerified: json['isVerified'] as bool? ?? false,
      isBlocked: json['isBlocked'] as bool? ?? false,
      isContact: json['isContact'] as bool? ?? false,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'coreId': instance.coreId,
      'name': instance.name,
      'iconUrl': instance.iconUrl,
      'walletAddress': instance.walletAddress,
      'nickname': instance.nickname,
      'isOnline': instance.isOnline,
      'isVerified': instance.isVerified,
      'isBlocked': instance.isBlocked,
      'isContact': instance.isContact,
    };
