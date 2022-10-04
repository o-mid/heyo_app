import '../models/messages/message_model.dart';
import '../repo/messages_abstract_repo.dart';

class DeleteMessage {
  final MessagesAbstractRepo messagesRepo;

  DeleteMessage({required this.messagesRepo});

  execute({required DeleteMessageType deleteMessageType}) async {
    switch (deleteMessageType.runtimeType) {
      case DeleteLocalMessages:
        final localMessages = (deleteMessageType as DeleteLocalMessages).selectedMessages;
        final messageIds = localMessages.map((e) => e.messageId).toList();
        await messagesRepo.deleteMessages(messageIds: messageIds, chatId: deleteMessageType.chatId);
        break;

      case DeleteRemoteMessages:
        // Todo: libp2p - delete for others
        final remoteMessages = (deleteMessageType as DeleteRemoteMessages).selectedMessages;
        final messageIds = remoteMessages.map((e) => e.messageId).toList();
        await messagesRepo.deleteMessages(messageIds: messageIds, chatId: deleteMessageType.chatId);
        break;
    }
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
