import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:heyo/app/modules/messaging/usecases/send_binary_data_usecase.dart';
import 'package:tuple/tuple.dart';

import '../controllers/common_messaging_controller.dart';
import '../controllers/messaging_connection_controller.dart';
import '../models/data_channel_message_model.dart';
import '../utils/binary_file_sending_state.dart';
import '../utils/channel_message_from_type.dart';

class SendDataChannelMessage {
  CommonMessagingConnectionController messagingConnection;

  SendDataChannelMessage({
    required this.messagingConnection,
  });

  execute(
      {required ChannelMessageType channelMessageType,
      required String remoteCoreId}) async {
    Tuple3<DataChannelMessageModel?, bool, String> channelMessageObject =
        channelmessageFromType(channelMessageType: channelMessageType);
    DataChannelMessageModel? msg = channelMessageObject.item1;
    bool isDataBinary = channelMessageObject.item2;
    String messageLocalPath = channelMessageObject.item3;

    if (msg == null) {
      return;
    }

    Map<String, dynamic> message = msg.toJson();
    if (isDataBinary && messageLocalPath.isNotEmpty) {
      BinaryFileSendingState sendingState = await BinaryFileSendingState.create(
        file: File(messageLocalPath),
        meta: msg.message,
      );
      await SendBinaryData(sendingState: sendingState).execute(remoteCoreId);
    } else {
      messagingConnection.sendTextMessage(text: jsonEncode(message),remoteCoreId: remoteCoreId);
    }
  }
}

class ChannelMessageType {
  factory ChannelMessageType.message(
      {required Map<String, dynamic> message,
      required bool isDataBinary,
      required String messageLocalPath}) = SendMessage;

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
  final bool isDataBinary;
  final String messageLocalPath;

  SendMessage({
    required this.message,
    required this.isDataBinary,
    required this.messageLocalPath,
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
