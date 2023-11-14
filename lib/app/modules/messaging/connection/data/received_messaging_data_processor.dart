import 'dart:convert';
import 'package:heyo/app/modules/messages/data/models/messages/confirm_message_model.dart';
import 'package:heyo/app/modules/messaging/connection/connection_data_handler.dart';
import 'package:heyo/app/modules/messaging/connection/data/data_channel_messaging_connection.dart';
import 'package:heyo/app/modules/messaging/connection/domain/messaging_connections_models.dart';
import 'package:heyo/app/modules/messaging/models/data_channel_message_model.dart';

class ReceivedMessageDataProcessor {
  ReceivedMessageDataProcessor({
    required this.dataChannelMessagingConnection,
    required this.dataHandler,
  }) {
    _init();
  }

  void _init() {
    dataChannelMessagingConnection.getMessageStream().listen((event) async {
      await dataHandler.createUserChatModel(sessioncid: event.remoteCoreId);
      onDataReceived(event, MessageConnectionType.RTC_DATA_CHANNEL);
    });
  }

  final DataChannelMessagingConnection dataChannelMessagingConnection;
  final DataHandler dataHandler;

  void onDataReceived(
    MessagingConnectionReceivedData messagingConnectionReceivedData,
    MessageConnectionType messageConnectionType,
  ) {
    handleMessageReceived(
      receivedJson: messagingConnectionReceivedData.receivedJson,
      remoteCoreId: messagingConnectionReceivedData.remoteCoreId,
      messageConnectionType: messageConnectionType,
    );
  }

  /// Handles text data, received from remote peer.
  Future<void> handleMessageReceived(
      {required Map<String, dynamic> receivedJson,
      required String remoteCoreId,
      required MessageConnectionType messageConnectionType}) async {
    WrappedMessageModel wrappedMessageModel =
        WrappedMessageModel.fromJson(receivedJson);

    switch (wrappedMessageModel.dataChannelMessagetype) {
      case MessageType.message:
        var confirmationValues = await dataHandler.saveReceivedMessage(
          receivedMessageJson: wrappedMessageModel.message,
          chatId: remoteCoreId,
        );
        await confirmMessageById(
          messageId: confirmationValues.item1,
          status: confirmationValues.item2,
          remoteCoreId: confirmationValues.item3,
          messageConnectionType: messageConnectionType,
        );

      case MessageType.delete:
        await dataHandler.deleteReceivedMessage(
          receivedDeleteJson: wrappedMessageModel.message,
          chatId: remoteCoreId,
        );

      case MessageType.update:
        await dataHandler.updateReceivedMessage(
          receivedUpdateJson: wrappedMessageModel.message,
          chatId: remoteCoreId,
        );

      case MessageType.confirm:
        await dataHandler.confirmReceivedMessage(
          receivedconfirmJson: wrappedMessageModel.message,
          chatId: remoteCoreId,
        );
    }
  }

  Future<void> confirmMessageById({
    required String messageId,
    required ConfirmMessageStatus status,
    required String remoteCoreId,
    required MessageConnectionType messageConnectionType,
  }) async {
    final confirmMessageJson =
        ConfirmMessageModel(messageId: messageId, status: status).toJson();

    final wrappedMessageModel = WrappedMessageModel(
      message: confirmMessageJson,
      dataChannelMessagetype: MessageType.confirm,
    );

    if (messageConnectionType == MessageConnectionType.RTC_DATA_CHANNEL) {
      await dataChannelMessagingConnection.sendMessage(
        DataChannelConnectionSendData(
          remoteCoreId: remoteCoreId,
          message: jsonEncode(wrappedMessageModel.toJson()),
        ),
      );
    } else {
      //TODO wifidirect
    }
  }
}
