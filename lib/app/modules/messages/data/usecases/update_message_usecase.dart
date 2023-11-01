import 'dart:convert';

import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/update_message_model.dart';

import '../../../messaging/controllers/common_messaging_controller.dart';
import '../../../messaging/controllers/messaging_connection_controller.dart';
import '../../../messaging/unified_messaging_controller.dart';
import '../message_processor.dart';
import '../models/messages/message_model.dart';
import '../models/reaction_model.dart';
import '../provider/messages_provider.dart';
import '../repo/messages_abstract_repo.dart';
import '../repo/messages_repo.dart';

class UpdateMessageUseCase {
  UpdateMessageUseCase({
    required this.messagesRepo,
    required this.messagingConnection,
    required this.processor,
  });
  final MessagesAbstractRepo messagesRepo;
  final UnifiedConnectionController messagingConnection;
  final MessageProcessor processor;

  Future<void> execute(
      {required UpdateMessageType updateMessageType, required String remoteCoreId}) async {
    switch (updateMessageType.runtimeType) {
      case UpdateReactions:
        final message = (updateMessageType as UpdateReactions).selectedMessage;

        final emoji = (updateMessageType).emoji;

        await updateReactions(
          message: message,
          chatId: updateMessageType.chatId,
          emoji: emoji,
          remoteCoreId: remoteCoreId,
        );

        break;
    }
  }

  Future<void> updateReactions({
    required MessageModel message,
    required String emoji,
    required String chatId,
    required String remoteCoreId,
  }) async {
    final localCoreID = await messagingConnection.accountInfo.getCorePassCoreId() ?? "";
    var reaction = message.reactions[emoji] as ReactionModel? ?? ReactionModel();

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

    var updatedMessageJson =
        UpdateMessageModel(message: updatedMessage.copyWith(reactions: updatedMessage.reactions))
            .toJson();

    // await SendDataChannelMessage(messagingConnection: messagingConnection).execute(
    //   remoteCoreId: remoteCoreId,
    //   channelMessageType: ChannelMessageType.update(message: updatedMessageJson),
    // );

    final processedMessage = await processor.getMessageDetails(
      channelMessageType: ChannelMessageType.update(message: updatedMessageJson),
      remoteCoreId: remoteCoreId,
    );

    await messagingConnection.sendTextMessage(
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
