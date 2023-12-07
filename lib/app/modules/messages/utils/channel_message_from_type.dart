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
      );
      isDataBinary = (channelMessageType).isDataBinary;
      messageLocalPath = (channelMessageType).messageLocalPath;
      break;

    case DeleteMessageType:
      msg = WrappedMessageModel(
        message: (channelMessageType as DeleteMessageType).message,
        dataChannelMessagetype: MessageType.delete,
      );

      break;
    case UpdateMessageType:
      msg = WrappedMessageModel(
        message: (channelMessageType as WrappedMessageModel).message,
        dataChannelMessagetype: MessageType.update,
      );
      break;

    case ConfirmMessageType:
      msg = WrappedMessageModel(
        message: (channelMessageType as ConfirmMessageType).message,
        dataChannelMessagetype: MessageType.confirm,
      );
  }

  return Tuple3(msg, isDataBinary, messageLocalPath);
}
