import 'package:heyo/app/modules/messages/connection/domain/messaging_connection.dart';
import 'package:heyo/app/modules/messages/connection/models/data_channel_message_model.dart';
import 'package:heyo/app/modules/messages/connection/models/models.dart';
import 'package:heyo/app/modules/shared/data/models/messages_view_arguments_model.dart';
import 'package:heyo/app/modules/messages/connection/models/data_channel_message_model.dart';

class MessagingConnectionReceivedData {
  MessagingConnectionReceivedData({
    required this.remoteCoreId,
    required this.remoteCoreIds,
    required this.chatName,
    required this.receivedJson,
    required this.chatId,
    required this.isGroupChat,
  });

  final Map<String, dynamic> receivedJson;

  final ChatId chatId;
  final bool isGroupChat;
  final String chatName;
  final String remoteCoreId;
  final List<String> remoteCoreIds;
}

sealed class MessagingConnectionInitialData {
  final String remoteId;
  final ChatId chatId;
  final bool isGroupChat;
  final String chatName;
  final List<String> remoteCoreIds;
  MessagingConnectionInitialData(
      {required this.remoteCoreIds,
      required this.chatId,
      required this.remoteId,
      required this.isGroupChat,
      required this.chatName});
}

sealed class MessagingConnectionSendData {}

enum MessagingConnectionStatus { connectionLost, connecting, justConnected, online }

class WebRTCConnectionInitData extends MessagingConnectionInitialData {
  WebRTCConnectionInitData(
      {required super.remoteId,
      required super.remoteCoreIds,
      required super.chatId,
      required super.isGroupChat,
      required super.chatName});
}

class DataChannelConnectionSendData extends MessagingConnectionSendData {
  DataChannelConnectionSendData({
    required this.remoteCoreId,
    required this.message,
    required this.chatId,
    required this.isGroupChat,
    required this.chatName,
    required this.remoteCoreIds,
  });

  final String remoteCoreId;
  final String message;
  final ChatId chatId;
  final bool isGroupChat;
  final String chatName;
  final List<String> remoteCoreIds;
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
