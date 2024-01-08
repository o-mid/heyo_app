import 'package:heyo/app/modules/messages/connection/domain/messaging_connection.dart';
import 'package:heyo/app/modules/messages/connection/models/data_channel_message_model.dart';
import 'package:heyo/app/modules/messages/connection/models/models.dart';
import 'package:heyo/app/modules/shared/data/models/messages_view_arguments_model.dart';
import 'package:heyo/app/modules/messages/connection/models/data_channel_message_model.dart';

class MessagingConnectionReceivedData {
  MessagingConnectionReceivedData({
    required this.remoteCoreId,
    required this.receivedJson,
    required this.chatId,
    required this.isGroupChat,
  });

  final Map<String, dynamic> receivedJson;
  final String remoteCoreId;
  final ChatId chatId;
  final bool isGroupChat;
}

sealed class MessagingConnectionInitialData {
  final String remoteId;
  final ChatId chatId;
  final bool isGroupChat;
  MessagingConnectionInitialData(
      {required this.remoteId, required this.chatId, required this.isGroupChat});
}

sealed class MessagingConnectionSendData {}

enum MessagingConnectionStatus { connectionLost, connecting, justConnected, online }

class WebRTCConnectionInitData extends MessagingConnectionInitialData {
  WebRTCConnectionInitData(
      {required super.remoteId, required super.chatId, required super.isGroupChat});
}

class DataChannelConnectionSendData extends MessagingConnectionSendData {
  DataChannelConnectionSendData(
      {required this.remoteCoreId,
      required this.message,
      required this.chatId,
      required this.isGroupChat});

  final String remoteCoreId;
  final String message;
  final ChatId chatId;
  final bool isGroupChat;
}

extension MapToMessageConnectionType on MessagingConnectionType {
  MessageConnectionType map() {
    if (this == MessagingConnectionType.internet) {
      return MessageConnectionType.RTC_DATA_CHANNEL;
    } else {
      return MessageConnectionType.WIFI_DIRECT;
    }
  }
}
