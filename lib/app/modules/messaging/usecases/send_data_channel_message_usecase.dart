import 'dart:convert';
import 'dart:typed_data';

import 'package:bson/bson.dart';
import 'package:tuple/tuple.dart';

import '../controllers/messaging_connection_controller.dart';
import '../models/data_channel_message_model.dart';
import '../utils/channel_message_from_type.dart';

class SendDataChannelMessage {
  MessagingConnectionController messagingConnection;
  SendDataChannelMessage({
    required this.messagingConnection,
  });

  execute({
    required ChannelMessageType channelMessageType,
  }) async {
    final bson = BSON();

    Tuple2<DataChannelMessageModel?, bool> channelMessageObject =
        channelmessageFromType(channelMessageType: channelMessageType);
    DataChannelMessageModel? msg = channelMessageObject.item1;
    bool isDataBinery = channelMessageObject.item2;

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
