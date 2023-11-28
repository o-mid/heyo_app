import 'dart:convert';

import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/delete_message_model.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_repo.dart';
import 'package:heyo/app/modules/messaging/connection/connection_repo.dart';
import 'package:heyo/app/modules/messaging/models/data_channel_message_model.dart';

import '../../../messaging/unified_messaging_controller.dart';
import '../message_processor.dart';
import '../models/messages/message_model.dart';
import '../provider/messages_provider.dart';
import '../repo/messages_abstract_repo.dart';

class DeleteMessageUseCase {
  final MessagesAbstractRepo messagesRepo;
  final ConnectionRepository connectionRepository;
  final MessageProcessor processor;

  DeleteMessageUseCase({
    required this.messagesRepo,
    required this.connectionRepository,
    required this.processor,
  });

  Future<void> execute({
    required MessageConnectionType messageConnectionType,
    required DeleteMessageType deleteMessageType,
    required String remoteCoreId,
  }) async {
    switch (deleteMessageType.runtimeType) {
      case DeleteLocalMessages:
        final localMessages = (deleteMessageType as DeleteLocalMessages).selectedMessages;
        await deleteLocalMessages(localMessages: localMessages, chatId: deleteMessageType.chatId);
        break;

      case DeleteRemoteMessages:
        final remoteMessages = (deleteMessageType as DeleteRemoteMessages).selectedMessages;

        await deleteRemoteMessages(
          messageConnectionType: messageConnectionType,
          remoteMessages: remoteMessages,
          chatId: deleteMessageType.chatId,
          remoteCoreId: remoteCoreId,
        );
        break;
    }
  }

  Future<void> deleteLocalMessages({
    required List<MessageModel> localMessages,
    required String chatId,
  }) async {
    final messageIds = localMessages.map((e) => e.messageId).toList();
    await messagesRepo.deleteMessages(messageIds: messageIds, chatId: chatId);
  }

  Future<void> deleteRemoteMessages({
    required MessageConnectionType messageConnectionType,
    required List<MessageModel> remoteMessages,
    required String chatId,
    required String remoteCoreId,
  }) async {
    final messageIds = remoteMessages.map((e) => e.messageId).toList();

    final deleteMessagesJson = DeleteMessageModel(messageIds: messageIds).toJson();

    await messagesRepo.deleteMessages(messageIds: messageIds, chatId: chatId);

    final processedMessage = await processor.getMessageDetails(
      channelMessageType: ChannelMessageType.delete(message: deleteMessagesJson),
      remoteCoreId: remoteCoreId,
    );

    await connectionRepository.sendTextMessage(
      messageConnectionType: messageConnectionType,
      text: jsonEncode(processedMessage.messageJson),
      remoteCoreId: remoteCoreId,
    );
  }
}

class DeleteMessageType {
  DeleteMessageType({required this.chatId});

  factory DeleteMessageType.forMe({
    required List<MessageModel> selectedMessages,
    required String chatId,
  }) = DeleteLocalMessages;

  factory DeleteMessageType.forEveryone({
    required List<MessageModel> selectedMessages,
    required String chatId,
  }) = DeleteRemoteMessages;
  final String chatId;
}

class DeleteLocalMessages extends DeleteMessageType {
  DeleteLocalMessages({
    required super.chatId,
    required this.selectedMessages,
  });
  final List<MessageModel> selectedMessages;
}

class DeleteRemoteMessages extends DeleteMessageType {
  DeleteRemoteMessages({
    required super.chatId,
    required this.selectedMessages,
  });
  final List<MessageModel> selectedMessages;
}
