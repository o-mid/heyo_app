import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';

import '../../../utils/message_from_json.dart';

class UpdateMessageModel {
  static const messageSerializedName = 'message';
  MessageModel message;

  UpdateMessageModel({
    required this.message,
  });

  UpdateMessageModel copyWith({
    MessageModel? message,
  }) {
    return UpdateMessageModel(
      message: message ?? this.message,
    );
  }

  factory UpdateMessageModel.fromJson(Map<String, dynamic> json) => UpdateMessageModel(
        message: messageFromJson(json[messageSerializedName]),
      );

  Map<String, dynamic> toJson() => {
        messageSerializedName: message.toJson(),
      };
}
