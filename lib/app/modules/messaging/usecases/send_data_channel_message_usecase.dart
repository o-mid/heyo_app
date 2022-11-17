import 'dart:convert';
import 'dart:typed_data';

import 'package:bson/bson.dart';

import '../controllers/messaging_connection_controller.dart';
import '../models/data_channel_message_model.dart';

class SendDataChannelMessage {
  MessagingConnectionController messagingConnection;
  SendDataChannelMessage({
    required this.messagingConnection,
  });

  //TODO messaging: check models | move mapping objects to another function
  execute({
    required ChannelMessageType channelMessageType,
  }) async {
    bool isDataBinery = false;
    final bson = BSON();
    DataChannelMessageModel? msg;
    switch (channelMessageType.runtimeType) {
      case SendMessage:
        msg = DataChannelMessageModel(
          message: (channelMessageType as SendMessage).message,
          dataChannelMessagetype: DataChannelMessageType.message,
        );
        isDataBinery = (channelMessageType).isDataBinery;
        break;

      case DeleteMessage:
        msg = DataChannelMessageModel(
          message: (channelMessageType as DeleteMessage).message,
          dataChannelMessagetype: DataChannelMessageType.delete,
        );

        break;
      case UpdateMessage:
        msg = DataChannelMessageModel(
          message: (channelMessageType as UpdateMessage).message,
          dataChannelMessagetype: DataChannelMessageType.update,
        );
        break;

      case ConfirmMessage:
        msg = DataChannelMessageModel(
          message: (channelMessageType as ConfirmMessage).message,
          dataChannelMessagetype: DataChannelMessageType.confirm,
        );

      // Todo: Omid, add other case confirm
    }

    if (msg == null) {
      return;
    }

    Map<String, dynamic> message = msg.toJson();
    if (isDataBinery) {
      BsonBinary bsonBinary = bson.serialize(message);

      ByteBuffer byteBuffer = bsonBinary.byteList.buffer;
      const mAXIMUM_MESSAGE_SIZE = 14 * 1024;

      for (var i = 0; i < byteBuffer.lengthInBytes; i += mAXIMUM_MESSAGE_SIZE) {
        messagingConnection.sendBinaryMessage(
            binary: byteBuffer.asUint8List(i, i + mAXIMUM_MESSAGE_SIZE));
      }
    } else {
      messagingConnection.sendTextMessage(text: jsonEncode(message));
    }
  }
}

class ChannelMessageType {
  factory ChannelMessageType.message({
    required Map<String, dynamic> message,
    required bool isDataBinery,
  }) = SendMessage;

  factory ChannelMessageType.delete({
    required Map<String, dynamic> message,
  }) = DeleteMessage;

  factory ChannelMessageType.update({
    required Map<String, dynamic> message,
  }) = UpdateMessage;
  factory ChannelMessageType.confirm({
    required Map<String, dynamic> message,
  }) = UpdateMessage;
}

class SendMessage implements ChannelMessageType {
  final Map<String, dynamic> message;
  final bool isDataBinery;

  SendMessage({
    required this.message,
    required this.isDataBinery,
  });
}

class DeleteMessage implements ChannelMessageType {
  final Map<String, dynamic> message;

  DeleteMessage({
    required this.message,
  });
}

class UpdateMessage implements ChannelMessageType {
  final Map<String, dynamic> message;

  UpdateMessage({
    required this.message,
  });
}

class ConfirmMessage implements ChannelMessageType {
  final Map<String, dynamic> message;

  ConfirmMessage({
    required this.message,
  });
}
