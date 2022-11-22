import 'package:heyo/app/modules/messaging/usecases/send_data_channel_message_usecase.dart';
import 'package:tuple/tuple.dart';
import '../models/data_channel_message_model.dart';

Tuple2<DataChannelMessageModel?, bool> channelmessageFromType(
    {required ChannelMessageType channelMessageType}) {
  bool isDataBinery = false;
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
  }

  return Tuple2(msg, isDataBinery);
}
