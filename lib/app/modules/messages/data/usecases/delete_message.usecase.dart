import '../models/messages/message_model.dart';
import '../repo/messages_abstract_repo.dart';

class DeleteMessage {
  final MessagesAbstractRepo messagesRepo;

  DeleteMessage({required this.messagesRepo});

  factory DeleteMessage.forMe({
    required MessagesAbstractRepo messagesRepo,
    required List<MessageModel> selectedMessages,
  }) = DeleteLocalMessages;

  factory DeleteMessage.forEveryone({
    required MessagesAbstractRepo messagesRepo,
    required List<MessageModel> selectedMessages,
  }) = DeleteRemoteMessages;

  Future<void> execute({required String chatId}) async {
    switch (runtimeType) {
      case DeleteLocalMessages:
        final localMessages = (this as DeleteLocalMessages).selectedMessages;
        final messageIds = localMessages.map((e) => e.messageId).toList();
        await messagesRepo.deleteMessages(messageIds: messageIds, chatId: chatId);
        break;

      case DeleteRemoteMessages:
        // Todo: libp2p - delete for others
        final remoteMessages = (this as DeleteRemoteMessages).selectedMessages;
        final messageIds = remoteMessages.map((e) => e.messageId).toList();
        await messagesRepo.deleteMessages(messageIds: messageIds, chatId: chatId);
        break;
    }
  }
}

class DeleteLocalMessages extends DeleteMessage {
  final List<MessageModel> selectedMessages;
  DeleteLocalMessages({
    required super.messagesRepo,
    required this.selectedMessages,
  });
}

class DeleteRemoteMessages extends DeleteMessage {
  final List<MessageModel> selectedMessages;
  DeleteRemoteMessages({
    required super.messagesRepo,
    required this.selectedMessages,
  });
}
