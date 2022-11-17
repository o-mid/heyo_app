import '../../../messaging/controllers/messaging_connection_controller.dart';
import '../../../messaging/usecases/send_data_channel_message_usecase.dart';
import '../models/messages/confirm_message_model.dart';
import '../models/messages/message_model.dart';
import '../repo/messages_abstract_repo.dart';

//TODO messaging: ?
class ConfirmMessage {
  final MessagesAbstractRepo messagesRepo;
  MessagingConnectionController messagingConnection;
  ConfirmMessage({
    required this.messagesRepo,
    required this.messagingConnection,
  });
  execute({required ConfirmMessageType confirmMessageType}) async {
    switch (confirmMessageType.runtimeType) {
      case ConfirmReceivedText:
        final String messageId = (confirmMessageType as ConfirmReceivedText).messageId;

        Map<String, dynamic> confirmmessageJson = ConfirmMessageModel(
          messageId: messageId,
        ).toJson();

        SendDataChannelMessage(messagingConnection: messagingConnection).execute(
          channelMessageType: ChannelMessageType.confirm(message: confirmmessageJson),
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
  }) = ConfirmReceivedText;
}

class ConfirmReceivedText extends ConfirmMessageType {
  final String messageId;
  ConfirmReceivedText({
    required this.messageId,
    required super.chatId,
  });
}
