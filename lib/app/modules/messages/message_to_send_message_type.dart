import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/text_message_model.dart';
import 'package:heyo/app/modules/messages/data/usecases/send_message_usecase.dart';

SendMessageType? get(MessageModel messageModel,String chatId) {


  switch (messageModel.type) {
    case MessageContentType.text:
      {
        return SendMessageType.text(
            text: (messageModel as TextMessageModel).text,
            replyTo: messageModel.replyTo,
            chatId: chatId);
      }
    case MessageContentType.image:
      {
        return SendMessageType.image(
          path: ,
            text: (messageModel as TextMessageModel).,
            replyTo: messageModel.replyTo,
            chatId: chatId);
      };
  }
}