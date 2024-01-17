import 'dart:convert';

import 'package:heyo/app/modules/calls/shared/data/models/call_user_model.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';

class IncomingCallModel {
  String name;
  String iconUrl;
  String coreId;
  IncomingCallModel({
    required this.name,
    required this.iconUrl,
    required this.coreId,
  });

  IncomingCallModel copyWith({
    String? name,
    String? iconUrl,
    String? coreId,
  }) {
    return IncomingCallModel(
      name: name ?? this.name,
      iconUrl: iconUrl ?? this.iconUrl,
      coreId: coreId ?? this.coreId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'iconUrl': iconUrl,
      'coreId': coreId,
    };
  }

  factory IncomingCallModel.fromMap(Map<String, dynamic> map) {
    return IncomingCallModel(
      name: map['name'] as String,
      iconUrl: map['iconUrl'] as String,
      coreId: map['coreId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory IncomingCallModel.fromJson(String source) =>
      IncomingCallModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'IncomingCallModel(name: $name, iconUrl: $iconUrl, coreId: $coreId)';
}

extension UserModelToIncomingCallModel on UserModel {
  IncomingCallModel toIncomingCallModel() {
    return IncomingCallModel(
      name: name,
      iconUrl: "https://avatars.githubusercontent.com/u/2345136?v=4",
      coreId: coreId,
    );
  }
}

extension CallUserModelToIncomingCallModel on CallUserModel {
  IncomingCallModel toIncomingCallModel() {
    return IncomingCallModel(
      name: name,
      iconUrl: iconUrl,
      coreId: coreId,
    );
  }
}
