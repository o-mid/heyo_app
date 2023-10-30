import 'package:tuple/tuple.dart';

import '../../messaging/models/data_channel_message_model.dart';
import '../../messaging/utils/channel_message_from_type.dart';

// use this class insted of former SendDataChannelMessage class and execute method
class MessageProcessor {
  Future<MessageProcessingResult> getMessageDetails({
    required ChannelMessageType channelMessageType,
    required String remoteCoreId,
  }) async {
    Tuple3<DataChannelMessageModel?, bool, String> channelMessageObject =
        channelmessageFromType(channelMessageType: channelMessageType);

    DataChannelMessageModel? msg = channelMessageObject.item1;
    bool isDataBinary = channelMessageObject.item2;
    String messageLocalPath = channelMessageObject.item3;

    if (msg == null) {
      throw Exception("Message is null");
    }

    Map<String, dynamic> messageJson = msg.toJson();

    return MessageProcessingResult(
      messageJson: messageJson,
      isDataBinary: isDataBinary,
      messageLocalPath: messageLocalPath,
    );
  }
}

class MessageProcessingResult {
  final Map<String, dynamic> messageJson;
  final bool isDataBinary;
  final String messageLocalPath;

  MessageProcessingResult({
    required this.messageJson,
    required this.isDataBinary,
    required this.messageLocalPath,
  });
}

class ChannelMessageType {
  factory ChannelMessageType.message({
    required Map<String, dynamic> message,
    required bool isDataBinary,
    required String messageLocalPath,
  }) = SendMessageType;

  factory ChannelMessageType.delete({
    required Map<String, dynamic> message,
  }) = DeleteMessageType;

  factory ChannelMessageType.update({
    required Map<String, dynamic> message,
  }) = UpdateMessageType;

  factory ChannelMessageType.confirm({
    required Map<String, dynamic> message,
  }) = UpdateMessageType;
}

class SendMessageType implements ChannelMessageType {
  final Map<String, dynamic> message;
  final bool isDataBinary;
  final String messageLocalPath;

  SendMessageType({
    required this.message,
    required this.isDataBinary,
    required this.messageLocalPath,
  });
}

class DeleteMessageType implements ChannelMessageType {
  final Map<String, dynamic> message;

  DeleteMessageType({
    required this.message,
  });
}

class UpdateMessageType implements ChannelMessageType {
  final Map<String, dynamic> message;

  UpdateMessageType({
    required this.message,
  });
}

class ConfirmMessageType implements ChannelMessageType {
  final Map<String, dynamic> message;

  ConfirmMessageType({
    required this.message,
  });
}
