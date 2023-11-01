import 'dart:convert';

import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';

class CallUserModel {
  String name;
  String iconUrl;
  String walletAddress;
  bool isContact;
  String coreId;

  CallUserModel({
    required this.name,
    required this.iconUrl,
    required this.walletAddress,
    this.isContact = false,
    required this.coreId,
  });

  CallUserModel copyWith({
    String? name,
    String? iconUrl,
    String? walletAddress,
    bool? isContact,
    String? coreId,
  }) {
    return CallUserModel(
      name: name ?? this.name,
      iconUrl: iconUrl ?? this.iconUrl,
      walletAddress: walletAddress ?? this.walletAddress,
      isContact: isContact ?? this.isContact,
      coreId: coreId ?? this.coreId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'iconUrl': iconUrl,
      'walletAddress': walletAddress,
      'isContact': isContact,
      'coreId': coreId,
    };
  }

  factory CallUserModel.fromMap(Map<String, dynamic> map) {
    return CallUserModel(
      name: map['name'] as String,
      iconUrl: map['iconUrl'] as String,
      walletAddress: map['walletAddress'] as String,
      isContact: map['isContact'] as bool,
      coreId: map['coreId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CallUserModel.fromJson(String source) =>
      CallUserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CallUserModel(name: $name, iconUrl: $iconUrl, walletAddress: $walletAddress, isContact: $isContact, coreId: $coreId)';
  }
}

extension UserModelToCallUserModel on UserModel {
  CallUserModel toCallUserModel() {
    return CallUserModel(
      name: name,
      iconUrl: iconUrl,
      walletAddress: walletAddress,
      coreId: coreId,
      isContact: isContact,
    );
  }
}
