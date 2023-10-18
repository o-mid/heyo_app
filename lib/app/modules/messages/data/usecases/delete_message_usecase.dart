import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/delete_message_model.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_repo.dart';

import '../../../messaging/controllers/common_messaging_controller.dart';
import '../../../messaging/controllers/messaging_connection_controller.dart';
import '../../../messaging/unified_messaging_controller.dart';
import '../../../messaging/usecases/send_data_channel_message_usecase.dart';
import '../models/messages/message_model.dart';
import '../provider/messages_provider.dart';
import '../repo/messages_abstract_repo.dart';

class DeleteMessage {
  final MessagesAbstractRepo messagesRepo = MessagesRepo(
    messagesProvider: MessagesProvider(
      appDatabaseProvider: Get.find(),
    ),
  );
  final UnifiedConnectionController messagingConnection = Get.find<UnifiedConnectionController>();

  Future<void> execute({
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
    required List<MessageModel> remoteMessages,
    required String chatId,
    required String remoteCoreId,
  }) async {
    final messageIds = remoteMessages.map((e) => e.messageId).toList();

    final deleteMessagesJson = DeleteMessageModel(messageIds: messageIds).toJson();

    await messagesRepo.deleteMessages(messageIds: messageIds, chatId: chatId);

    await SendDataChannelMessage(messagingConnection: messagingConnection).execute(
      channelMessageType: ChannelMessageType.delete(message: deleteMessagesJson),
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
