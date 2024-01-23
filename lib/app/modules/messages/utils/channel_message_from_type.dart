import 'package:tuple/tuple.dart';
import '../../messages/data/message_processor.dart';
import '../connection/models/data_channel_message_model.dart';

Tuple3<WrappedMessageModel?, bool, String> channelmessageFromType(
    {required ChannelMessageType channelMessageType}) {
  bool isDataBinary = false;
  String messageLocalPath = '';
  WrappedMessageModel? msg;
  switch (channelMessageType.runtimeType) {
    case SendMessageType:
      msg = WrappedMessageModel(
        message: (channelMessageType as SendMessageType).message,
        dataChannelMessagetype: MessageType.message,
        remoteCoreIds: channelMessageType.remoteCoreIds,
        chatId: (channelMessageType).chatId,
        chatName: channelMessageType.chatName,
      );
      isDataBinary = (channelMessageType).isDataBinary;
      messageLocalPath = (channelMessageType).messageLocalPath;
      break;

    case DeleteMessageType:
      msg = WrappedMessageModel(
        message: (channelMessageType as DeleteMessageType).message,
        dataChannelMessagetype: MessageType.delete,
        remoteCoreIds: channelMessageType.remoteCoreIds,
        chatId: (channelMessageType).chatId,
        chatName: channelMessageType.chatName,
      );

      break;
    case UpdateMessageType:
      msg = WrappedMessageModel(
        message: (channelMessageType as UpdateMessageType).message,
        dataChannelMessagetype: MessageType.update,
        remoteCoreIds: channelMessageType.remoteCoreIds,
        chatId: (channelMessageType).chatId,
        chatName: channelMessageType.chatName,
      );
      break;

    case ConfirmMessageType:
      msg = WrappedMessageModel(
        message: (channelMessageType as ConfirmMessageType).message,
        dataChannelMessagetype: MessageType.confirm,
        remoteCoreIds: channelMessageType.remoteCoreIds,
        chatId: (channelMessageType).chatId,
        chatName: channelMessageType.chatName,
      );
  }

  return Tuple3(msg, isDataBinary, messageLocalPath);
}
