import 'dart:convert';

import 'package:get/get.dart';
import 'package:heyo/app/modules/messaging/unified_messaging_controller.dart';
import '../../../messaging/controllers/common_messaging_controller.dart';

import '../message_processor.dart';
import '../models/messages/confirm_message_model.dart';

import '../provider/messages_provider.dart';
import '../repo/messages_abstract_repo.dart';
import '../repo/messages_repo.dart';

class ConfirmMessage {
  ConfirmMessage({required this.processor});
  final MessagesAbstractRepo messagesRepo = MessagesRepo(
    messagesProvider: MessagesProvider(
      appDatabaseProvider: Get.find(),
    ),
  );
  final UnifiedConnectionController messagingConnection = Get.find<UnifiedConnectionController>();
  final MessageProcessor processor;

  execute({required ConfirmMessageType confirmMessageType, required String remoteCoreId}) async {
    switch (confirmMessageType.runtimeType) {
      case ConfirmReceivedText:
        final String messageId = (confirmMessageType as ConfirmReceivedText).messageId;
        final ConfirmMessageStatus status = (confirmMessageType).status;

        Map<String, dynamic> confirmmessageJson = ConfirmMessageModel(
          messageId: messageId,
          status: status,
        ).toJson();

        final processedMessage = await processor.getMessageDetails(
          channelMessageType: ChannelMessageType.confirm(message: confirmmessageJson),
          remoteCoreId: remoteCoreId,
        );

        await messagingConnection.sendTextMessage(
          text: jsonEncode(processedMessage.messageJson),
          remoteCoreId: remoteCoreId,
        );
        break;
    }
  }
}

class ConfirmMessageType {
  final String chatId;

  ConfirmMessageType({required this.chatId});

  factory ConfirmMessageType.confirmReceivedText({
    required String chatId,
    required String messageId,
    required ConfirmMessageStatus status,
  }) = ConfirmReceivedText;
}

class ConfirmReceivedText extends ConfirmMessageType {
  final String messageId;
  final ConfirmMessageStatus status;
  ConfirmReceivedText({
    required this.messageId,
    required super.chatId,
    required this.status,
  });
}
