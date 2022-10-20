import 'dart:convert';

import '../../../messaging/controllers/messaging_connection_controller.dart';
import '../../models/data_channel_message_model.dart';

class SendDataChannelMessage {
  MessagingConnectionController messagingConnection;
  SendDataChannelMessage({
    required this.messagingConnection,
  });

  execute({
    required ChannelMessageType channelMessageType,
  }) async {
    DataChannelMessageModel? msg;
    switch (channelMessageType.runtimeType) {
      case SendMessage:
        msg = DataChannelMessageModel(
          message: (channelMessageType as SendMessage).message,
          dataChannelMessagetype: DataChannelMessageType.message,
        );
        break;

      // Todo: Omid, add other cases for update and delete and confirm
    }

    if (msg == null) {
      return;
    }

    Map<String, dynamic> message = msg.toJson();

    messagingConnection.sendTextMessage(jsonEncode(message));
  }
}

class ChannelMessageType {
  factory ChannelMessageType.message({
    required Map<String, dynamic> message,
  }) = SendMessage;
}

class SendMessage implements ChannelMessageType {
  final Map<String, dynamic> message;

  SendMessage({
    required this.message,
  });
}
