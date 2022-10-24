import 'package:heyo/app/modules/messages/data/models/messages/update_message_model.dart';

import '../../../messaging/controllers/messaging_connection_controller.dart';
import '../../../messaging/controllers/usecases/send_data_channel_message_usecase.dart';
import '../models/messages/message_model.dart';
import '../models/reaction_model.dart';
import '../repo/messages_abstract_repo.dart';

class UpdateMessage {
  final MessagesAbstractRepo messagesRepo;
  MessagingConnectionController messagingConnection;

  UpdateMessage({
    required this.messagesRepo,
    required this.messagingConnection,
  });

  execute({required UpdateMessageType updateMessageType}) async {
    final String localCoreID = await messagingConnection.accountInfo.getCoreId() ?? "";
    switch (updateMessageType.runtimeType) {
      case UpdateReactions:
        final message = (updateMessageType as UpdateReactions).selectedMessage;

        final emoji = (updateMessageType).emoji;

        var reaction = message.reactions[emoji] ?? ReactionModel();

        if (reaction.isReactedByMe) {
          reaction.users.removeWhere((element) => element == localCoreID);
          reaction = reaction.copyWith(
            isReactedByMe: false,
          );
        } else {
          // Todo: add user core id
          reaction = reaction.copyWith(users: [...reaction.users, localCoreID]);
          reaction = reaction.copyWith(
            isReactedByMe: true,
          );
        }

        // reaction = reaction.copyWith(
        //   isReactedByMe: !reaction.isReactedByMe,
        // );

        MessageModel updatedMessage = message.copyWith(
          reactions: {
            ...message.reactions,
            emoji: reaction,
          },
        );
        await messagesRepo.updateMessage(message: updatedMessage, chatId: updateMessageType.chatId);

        Map<String, dynamic> updatedMessageJson = UpdateMessageModel(
                message: updatedMessage.copyWith(reactions: updatedMessage.reactions))
            .toJson();
        print(updatedMessageJson);
        SendDataChannelMessage(messagingConnection: messagingConnection).execute(
          channelMessageType: ChannelMessageType.update(message: updatedMessageJson),
        );

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
