import 'dart:convert';

import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/connection/connection_repo.dart';
import 'package:heyo/app/modules/messages/connection/domain/messaging_connection.dart';
import 'package:heyo/app/modules/messages/connection/models/data_channel_message_model.dart';

import '../../connection/models/models.dart';
import '../message_processor.dart';
import '../models/messages/confirm_message_model.dart';

import '../provider/messages_provider.dart';
import '../repo/messages_abstract_repo.dart';
import '../repo/messages_repo.dart';

class ConfirmMessageUseCase {
  final MessagesAbstractRepo messagesRepo;
  final ConnectionRepository connectionRepository;
  final MessageProcessor processor;

  ConfirmMessageUseCase({
    required this.messagesRepo,
    required this.connectionRepository,
    required this.processor,
  });

  void execute({
    required MessageConnectionType messageConnectionType,
    required ConfirmMessageType confirmMessageType,
    required List<String> remoteCoreIds,
    required ChatId chatId,
    required String chatName,
  }) async {
    switch (confirmMessageType.runtimeType) {
      case ConfirmReceivedText:
        final String messageId = (confirmMessageType as ConfirmReceivedText).messageId;
        final ConfirmMessageStatus status = (confirmMessageType).status;

        Map<String, dynamic> confirmmessageJson = ConfirmMessageModel(
          messageId: messageId,
          status: status,
        ).toJson();

        final processedMessage = await processor.getMessageDetails(
          channelMessageType: ChannelMessageType.confirm(
            message: confirmmessageJson,
            remoteCoreIds: remoteCoreIds,
            chatId: chatId,
            chatName: chatName,
          ),
        );

        await connectionRepository.sendTextMessage(
          messageConnectionType: MessageConnectionType.RTC_DATA_CHANNEL,
          text: jsonEncode(processedMessage.messageJson),
          remoteCoreIds: remoteCoreIds,
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
