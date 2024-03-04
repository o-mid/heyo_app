import 'dart:convert';

import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';

class IncomingCallModel {
  String name;
  String coreId;
  IncomingCallModel({
    required this.name,
    required this.coreId,
  });

  IncomingCallModel copyWith({
    String? name,
    String? iconUrl,
    String? coreId,
  }) {
    return IncomingCallModel(
      name: name ?? this.name,
      coreId: coreId ?? this.coreId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'coreId': coreId,
    };
  }

  factory IncomingCallModel.fromMap(Map<String, dynamic> map) {
    return IncomingCallModel(
      name: map['name'] as String,
      coreId: map['coreId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory IncomingCallModel.fromJson(String source) =>
      IncomingCallModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'IncomingCallModel(name: $name, coreId: $coreId)';
}

extension UserModelToIncomingCallModel on UserModel {
  IncomingCallModel toIncomingCallModel() {
    return IncomingCallModel(
      name: name,
      coreId: coreId,
    );
  }
}
