import 'dart:convert';
import 'package:heyo/app/modules/messages/data/models/messages/update_message_model.dart';
import 'package:heyo/app/modules/messaging/connection/connection_repo.dart';
import 'package:heyo/app/modules/messaging/models/data_channel_message_model.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';
import '../message_processor.dart';
import '../models/messages/message_model.dart';
import '../models/reaction_model.dart';
import '../repo/messages_abstract_repo.dart';

class UpdateMessageUseCase {
  UpdateMessageUseCase(
      {required this.messagesRepo,
      required this.connectionRepository,
      required this.processor,
      required this.accountInfo});

  final MessagesAbstractRepo messagesRepo;
  final ConnectionRepository connectionRepository;
  final MessageProcessor processor;
  final AccountInfo accountInfo;

  Future<void> execute(
      {required MessageConnectionType messageConnectionType,
      required UpdateMessageType updateMessageType,
      required String remoteCoreId}) async {
    switch (updateMessageType.runtimeType) {
      case UpdateReactions:
        final message = (updateMessageType as UpdateReactions).selectedMessage;

        final emoji = (updateMessageType).emoji;

        await updateReactions(
          messageConnectionType: messageConnectionType,
          message: message,
          chatId: updateMessageType.chatId,
          emoji: emoji,
          remoteCoreId: remoteCoreId,
        );

        break;
    }
  }

  Future<void> updateReactions({
    required MessageConnectionType messageConnectionType,
    required MessageModel message,
    required String emoji,
    required String chatId,
    required String remoteCoreId,
  }) async {
    final localCoreID = await accountInfo.getCorePassCoreId() ?? "";
    var reaction =
        message.reactions[emoji] as ReactionModel? ?? ReactionModel();

    if (reaction.isReactedByMe) {
      reaction.users.removeWhere((element) => element == localCoreID);
      reaction = reaction.copyWith(
        isReactedByMe: false,
      );
    } else {
      reaction = reaction.copyWith(users: [...reaction.users, localCoreID]);
      reaction = reaction.copyWith(
        isReactedByMe: true,
      );
    }

    var updatedMessage = message.copyWith(
      reactions: {
        ...message.reactions,
        emoji: reaction,
      },
    );
    await messagesRepo.updateMessage(message: updatedMessage, chatId: chatId);

    var updatedMessageJson = UpdateMessageModel(
            message:
                updatedMessage.copyWith(reactions: updatedMessage.reactions))
        .toJson();

    // await SendDataChannelMessage(messagingConnection: messagingConnection).execute(
    //   remoteCoreId: remoteCoreId,
    //   channelMessageType: ChannelMessageType.update(message: updatedMessageJson),
    // );

    final processedMessage = await processor.getMessageDetails(
      channelMessageType:
          ChannelMessageType.update(message: updatedMessageJson),
      remoteCoreId: remoteCoreId,
    );

    await connectionRepository.sendTextMessage(
      messageConnectionType: messageConnectionType,
      text: jsonEncode(processedMessage.messageJson),
      remoteCoreId: remoteCoreId,
    );
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
