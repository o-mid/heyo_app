import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/location_message_model.dart';

import '../../../../../generated/locales.g.dart';
import '../../data/models/messages/audio_message_model.dart';
import '../../data/models/messages/image_message_model.dart';
import '../../data/models/messages/message_model.dart';
import '../../data/models/messages/multi_media_message_model.dart';
import '../../data/models/messages/text_message_model.dart';
import '../../data/models/messages/video_message_model.dart';

extension MessageModelHelpers on MessageModel {
  String getReplyMsgText() {
    String replyMsg = "";
    switch (runtimeType) {
      case TextMessageModel:
        replyMsg = (MessageModel as TextMessageModel).text;
        break;
      case ImageMessageModel:
        replyMsg = LocaleKeys.MessagesPage_replyToImage.tr;
        break;
      case VideoMessageModel:
        // Todo: use video metadata to show video duration
        replyMsg = LocaleKeys.MessagesPage_replyToVideo.tr;
        break;
      case AudioMessageModel:
        // Todo: use video metadata to show audio duration
        replyMsg = LocaleKeys.MessagesPage_replyToAudio.tr;
        break;
      case MultiMediaMessageModel:
        replyMsg = LocaleKeys.MessagesPage_replyToMultiMedia.tr;
        break;

      case LocationMessageModel:
        replyMsg = LocaleKeys.MessagesPage_replyToLocation.tr;
        break;
    }

    return replyMsg;
  }
}
