// ignore_for_file: require_trailing_commas

import 'dart:convert';
import 'package:heyo/app/modules/messages/data/models/messages/confirm_message_model.dart';
import 'package:heyo/app/modules/messages/connection/connection_data_handler.dart';
import 'package:heyo/app/modules/messages/connection/data/data_channel_messaging_connection.dart';
import 'package:heyo/app/modules/messages/connection/domain/messaging_connections_models.dart';
import 'package:heyo/app/modules/messages/connection/models/data_channel_message_model.dart';

import '../models/models.dart';

class ReceivedMessageDataProcessor {
  ReceivedMessageDataProcessor({
    required this.dataChannelMessagingConnection,
    required this.dataHandler,
  }) {
    _init();
  }

  void _init() {
    dataChannelMessagingConnection.getMessageStream().listen((event) async {
      //await dataHandler.createUserChatModel(sessioncid: event.remoteCoreId);
      onDataReceived(event, MessageConnectionType.RTC_DATA_CHANNEL);
    });
  }

  final DataChannelMessagingConnection dataChannelMessagingConnection;
  final DataHandler dataHandler;

  Future<void> onDataReceived(
    MessagingConnectionReceivedData messagingConnectionReceivedData,
    MessageConnectionType messageConnectionType,
  ) async {
    var wrappedMessageModel =
        WrappedMessageModel.fromJson(messagingConnectionReceivedData.receivedJson);

    await dataHandler.createChatModel(
        chatId: wrappedMessageModel.chatId,
        chatName: wrappedMessageModel.chatName,
        remoteCoreIds: wrappedMessageModel.remoteCoreIds);

    await handleMessageReceived(
      receivedJson: messagingConnectionReceivedData.receivedJson,
      remoteCoreId: messagingConnectionReceivedData.remoteCoreId,
      messageConnectionType: messageConnectionType,
      remoteCoreIds: wrappedMessageModel.remoteCoreIds,
    );
  }

  /// Handles text data, received from remote peer.
  Future<void> handleMessageReceived({
    required Map<String, dynamic> receivedJson,
    required String remoteCoreId,
    required MessageConnectionType messageConnectionType,
    required List<String> remoteCoreIds,
  }) async {
    WrappedMessageModel wrappedMessageModel = WrappedMessageModel.fromJson(receivedJson);
    final selfId = await dataHandler.accountInfoRepo.getUserAddress();

    List<String> newRemoteCoreIds = wrappedMessageModel.remoteCoreIds;
    if (newRemoteCoreIds.contains(selfId)) {
      newRemoteCoreIds.remove(selfId);
    }
    final isGroupChat = newRemoteCoreIds.length > 1;

    switch (wrappedMessageModel.dataChannelMessagetype) {
      case MessageType.message:
        var confirmationValues = await dataHandler.saveReceivedMessage(
          receivedMessageJson: wrappedMessageModel.message,
          chatId: wrappedMessageModel.chatId,
          coreId: remoteCoreId,
          isGroupChat: isGroupChat,
          remoteCoreIds: remoteCoreIds,
          chatName: wrappedMessageModel.chatName,
        );
        await confirmMessageById(
          messageId: confirmationValues.item1,
          status: confirmationValues.item2,
          remoteCoreId: remoteCoreId,
          messageConnectionType: messageConnectionType,
          chatId: wrappedMessageModel.chatId,
          isGroupChat: isGroupChat,
          remoteCoreIds: remoteCoreIds,
        );

      case MessageType.delete:
        await dataHandler.deleteReceivedMessage(
          receivedDeleteJson: wrappedMessageModel.message,
          chatId: wrappedMessageModel.chatId,
        );

      case MessageType.update:
        await dataHandler.updateReceivedMessage(
          receivedUpdateJson: wrappedMessageModel.message,
          chatId: wrappedMessageModel.chatId,
        );

      case MessageType.confirm:
        await dataHandler.confirmReceivedMessage(
          receivedconfirmJson: wrappedMessageModel.message,
          chatId: wrappedMessageModel.chatId,
        );
    }
  }

  Future<void> confirmMessageById({
    required String messageId,
    required ConfirmMessageStatus status,
    required String remoteCoreId,
    required ChatId chatId,
    required bool isGroupChat,
    required MessageConnectionType messageConnectionType,
    required List<String> remoteCoreIds,
  }) async {
    final confirmMessageJson = ConfirmMessageModel(messageId: messageId, status: status).toJson();

    final wrappedMessageModel = WrappedMessageModel(
      message: confirmMessageJson,
      dataChannelMessagetype: MessageType.confirm,
      chatId: chatId,
      chatName: await dataHandler.getChatName(chatId: chatId),
      remoteCoreIds: remoteCoreIds,
    );
    final chatName = await dataHandler.getChatName(chatId: chatId);
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
