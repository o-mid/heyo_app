import 'package:tuple/tuple.dart';
import '../../messages/data/message_processor.dart';
import '../models/data_channel_message_model.dart';

Tuple3<DataChannelMessageModel?, bool, String> channelmessageFromType(
    {required ChannelMessageType channelMessageType}) {
  bool isDataBinary = false;
  String messageLocalPath = '';
  DataChannelMessageModel? msg;
  switch (channelMessageType.runtimeType) {
    case SendMessageType:
      msg = DataChannelMessageModel(
        message: (channelMessageType as SendMessageType).message,
        dataChannelMessagetype: DataChannelMessageType.message,
      );
      isDataBinary = (channelMessageType).isDataBinary;
      messageLocalPath = (channelMessageType).messageLocalPath;
      break;

    case DeleteMessageType:
      msg = DataChannelMessageModel(
        message: (channelMessageType as DeleteMessageType).message,
        dataChannelMessagetype: DataChannelMessageType.delete,
      );

      break;
    case UpdateMessageType:
      msg = DataChannelMessageModel(
        message: (channelMessageType as DataChannelMessageModel).message,
        dataChannelMessagetype: DataChannelMessageType.update,
      );
      break;

    case ConfirmMessageType:
      msg = DataChannelMessageModel(
        message: (channelMessageType as ConfirmMessageType).message,
        dataChannelMessagetype: DataChannelMessageType.confirm,
      );
  }

  return Tuple3(msg, isDataBinary, messageLocalPath);
}
