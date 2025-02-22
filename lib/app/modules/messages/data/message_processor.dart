import 'package:tuple/tuple.dart';

import '../connection/models/data_channel_message_model.dart';
import '../utils/channel_message_from_type.dart';

// use this class insted of former SendDataChannelMessage class and execute method
class MessageProcessor {
  Future<MessageProcessingResult> getMessageDetails({
    required ChannelMessageType channelMessageType,
  }) async {
    Tuple3<WrappedMessageModel?, bool, String> channelMessageObject =
        channelmessageFromType(channelMessageType: channelMessageType);

    WrappedMessageModel? msg = channelMessageObject.item1;
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
    required String chatId,
    required String chatName,
    required List<String> remoteCoreIds,
  }) = SendMessageType;

  factory ChannelMessageType.delete({
    required Map<String, dynamic> message,
    required String chatId,
    required String chatName,
    required List<String> remoteCoreIds,
  }) = DeleteMessageType;

  factory ChannelMessageType.update({
    required Map<String, dynamic> message,
    required String chatId,
    required String chatName,
    required List<String> remoteCoreIds,
  }) = UpdateMessageType;

  factory ChannelMessageType.confirm({
    required Map<String, dynamic> message,
    required String chatId,
    required String chatName,
    required List<String> remoteCoreIds,
  }) = UpdateMessageType;
}

class SendMessageType implements ChannelMessageType {
  final Map<String, dynamic> message;
  final bool isDataBinary;
  final String messageLocalPath;
  final String chatId;
  final List<String> remoteCoreIds;
  final String chatName;

  SendMessageType({
    required this.message,
    required this.isDataBinary,
    required this.messageLocalPath,
    required this.chatId,
    required this.remoteCoreIds,
    required this.chatName,
  });
}

class DeleteMessageType implements ChannelMessageType {
  final Map<String, dynamic> message;
  final String chatId;

  final String chatName;
  final List<String> remoteCoreIds;

  DeleteMessageType({
    required this.message,
    required this.chatId,
    required this.remoteCoreIds,
    required this.chatName,
  });
}

class UpdateMessageType implements ChannelMessageType {
  final Map<String, dynamic> message;
  final String chatId;

  final String chatName;
  final List<String> remoteCoreIds;

  UpdateMessageType({
    required this.message,
    required this.chatId,
    required this.remoteCoreIds,
    required this.chatName,
  });
}

class ConfirmMessageType implements ChannelMessageType {
  final Map<String, dynamic> message;
  final String chatId;

  final String chatName;
  final List<String> remoteCoreIds;

  ConfirmMessageType({
    required this.message,
    required this.chatId,
    required this.remoteCoreIds,
    required this.chatName,
  });
}
