import '../models/messages/message_model.dart';
import '../models/reaction_model.dart';
import '../repo/messages_abstract_repo.dart';

class UpdateMessage {
  final MessagesAbstractRepo messagesRepo;

  UpdateMessage({required this.messagesRepo});

  factory UpdateMessage.updateReactions({
    required MessagesAbstractRepo messagesRepo,
    required MessageModel selectedMessage,
    required String emoji,
  }) = UpdateReactions;

  Future<void> execute({required String chatId}) async {
    switch (runtimeType) {
      case UpdateReactions:
        final message = (this as UpdateReactions).selectedMessage;

        final emoji = (this as UpdateReactions).emoji;

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
            chatId: chatId);
        // Todo: send updated reactions with libp2p
        break;
    }
  }
}

class UpdateReactions extends UpdateMessage {
  final MessageModel selectedMessage;
  final String emoji;
  UpdateReactions({
    required super.messagesRepo,
    required this.selectedMessage,
    required this.emoji,
  });
}
