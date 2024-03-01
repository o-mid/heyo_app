import 'dart:convert';

import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';

class CallUserModel {
  String name;
  String walletAddress;
  bool isContact;
  String coreId;

  CallUserModel({
    required this.name,
    required this.walletAddress,
    this.isContact = false,
    required this.coreId,
  });

  CallUserModel copyWith({
    String? name,
    String? walletAddress,
    bool? isContact,
    String? coreId,
  }) {
    return CallUserModel(
      name: name ?? this.name,
      walletAddress: walletAddress ?? this.walletAddress,
      isContact: isContact ?? this.isContact,
      coreId: coreId ?? this.coreId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'walletAddress': walletAddress,
      'isContact': isContact,
      'coreId': coreId,
    };
  }

  factory CallUserModel.fromMap(Map<String, dynamic> map) {
    return CallUserModel(
      name: map['name'] as String,
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
    return 'CallUserModel(name: $name, walletAddress: $walletAddress, isContact: $isContact, coreId: $coreId)';
  }
}

extension UserModelToCallUserModel on UserModel {
  CallUserModel toCallUserModel() {
    return CallUserModel(
      name: name,
      walletAddress: walletAddress,
      coreId: coreId,
      isContact: isContact,
    );
  }
}
