import 'package:heyo/app/modules/messaging/connection/domain/messaging_connection.dart';
import 'package:heyo/app/modules/messaging/models/data_channel_message_model.dart';
import 'package:heyo/app/modules/shared/data/models/messages_view_arguments_model.dart';
import 'package:heyo/app/modules/messaging/models/data_channel_message_model.dart';

class MessagingConnectionReceivedData {
  MessagingConnectionReceivedData({
    required this.remoteCoreId,
    required this.receivedJson,
  });

  final Map<String, dynamic> receivedJson;
  final String remoteCoreId;
}

sealed class MessagingConnectionInitialData {
  final String remoteId;
  MessagingConnectionInitialData({required this.remoteId});
}

sealed class MessagingConnectionSendData {}

enum MessagingConnectionStatus {
  connectionLost,
  connecting,
  justConnected,
  online
}

class WebRTCConnectionInitData extends MessagingConnectionInitialData {
  WebRTCConnectionInitData({required super.remoteId});
}

class DataChannelConnectionSendData extends MessagingConnectionSendData {
  DataChannelConnectionSendData({
    required this.remoteCoreId,
    required this.message,
  });

  final String remoteCoreId;
  final String message;
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
