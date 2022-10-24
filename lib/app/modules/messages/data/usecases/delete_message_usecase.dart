import 'package:heyo/app/modules/messages/data/models/messages/delete_message_model.dart';

import '../../../messaging/controllers/messaging_connection_controller.dart';
import '../../../messaging/controllers/usecases/send_data_channel_message_usecase.dart';
import '../models/messages/message_model.dart';
import '../repo/messages_abstract_repo.dart';

class DeleteMessage {
  final MessagesAbstractRepo messagesRepo;
  MessagingConnectionController messagingConnection;

  DeleteMessage({
    required this.messagesRepo,
    required this.messagingConnection,
  });

  execute({required DeleteMessageType deleteMessageType}) async {
    switch (deleteMessageType.runtimeType) {
      case DeleteLocalMessages:
        final localMessages = (deleteMessageType as DeleteLocalMessages).selectedMessages;
        await deleteLocalMessages(localMessages: localMessages, chatId: deleteMessageType.chatId);
        break;

      case DeleteRemoteMessages:
        final remoteMessages = (deleteMessageType as DeleteRemoteMessages).selectedMessages;

        await deleteRemoteMessages(
            remoteMessages: remoteMessages, chatId: deleteMessageType.chatId);
        break;
    }
  }

  Future<void> deleteLocalMessages(
      {required List<MessageModel> localMessages, required String chatId}) async {
    final messageIds = localMessages.map((e) => e.messageId).toList();
    await messagesRepo.deleteMessages(messageIds: messageIds, chatId: chatId);
  }

  Future<void> deleteRemoteMessages(
      {required List<MessageModel> remoteMessages, required String chatId}) async {
    final messageIds = remoteMessages.map((e) => e.messageId).toList();

    Map<String, dynamic> deleteMessagesJson = DeleteMessageModel(messageIds: messageIds).toJson();

    await messagesRepo.deleteMessages(messageIds: messageIds, chatId: chatId);

    await SendDataChannelMessage(messagingConnection: messagingConnection).execute(
      channelMessageType: ChannelMessageType.delete(message: deleteMessagesJson),
    );
  }
}

class DeleteMessageType {
  final String chatId;

  DeleteMessageType({required this.chatId});

  factory DeleteMessageType.forMe({
    required List<MessageModel> selectedMessages,
    required String chatId,
  }) = DeleteLocalMessages;

  factory DeleteMessageType.forEveryone({
    required List<MessageModel> selectedMessages,
    required String chatId,
  }) = DeleteRemoteMessages;
}

class DeleteLocalMessages extends DeleteMessageType {
  final List<MessageModel> selectedMessages;
  DeleteLocalMessages({
    required super.chatId,
    required this.selectedMessages,
  });
}

class DeleteRemoteMessages extends DeleteMessageType {
  final List<MessageModel> selectedMessages;
  DeleteRemoteMessages({
    required super.chatId,
    required this.selectedMessages,
  });
}
