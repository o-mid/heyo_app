import '../models/messages/message_model.dart';
import '../models/reaction_model.dart';
import '../repo/messages_abstract_repo.dart';

class UpdateMessage {
  final MessagesAbstractRepo messagesRepo;

  UpdateMessage({
    required this.messagesRepo,
  });

  execute({required UpdateMessageType updateMessageType}) async {
    switch (updateMessageType.runtimeType) {
      case UpdateReactions:
        final message = (updateMessageType as UpdateReactions).selectedMessage;

        final emoji = (updateMessageType).emoji;

        var reaction = message.reactions[emoji] ?? ReactionModel();

        if (reaction.isReactedByMe) {
          // Todo: remove user core id from list
          reaction.users.removeLast();
        } else {
          // Todo: add user core id
          reaction = reaction.copyWith(users: [...reaction.users, ""]);
        }

        reaction = reaction.copyWith(
          isReactedByMe: !reaction.isReactedByMe,
        );

        await messagesRepo.updateMessage(
            message: message.copyWith(reactions: {...message.reactions, emoji: reaction}),
            chatId: updateMessageType.chatId);
        // Todo: send updated reactions with libp2p
        break;
    }
  }
}

class UpdateMessageType {
  final String chatId;

  UpdateMessageType({required this.chatId});

  factory UpdateMessageType.updateReactions({
    required MessageModel selectedMessage,
    required String emoji,
    required String chatId,
  }) = UpdateReactions;
}

class UpdateReactions extends UpdateMessageType {
  final MessageModel selectedMessage;
  final String emoji;
  UpdateReactions({
    required this.selectedMessage,
    required this.emoji,
    required super.chatId,
  });
}
