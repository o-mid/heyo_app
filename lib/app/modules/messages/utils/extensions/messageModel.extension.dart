import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/call_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/file_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/location_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';

import '../../../../../generated/locales.g.dart';
import '../../data/models/messages/audio_message_model.dart';
import '../../data/models/messages/image_message_model.dart';
import '../../data/models/messages/message_model.dart';
import '../../data/models/messages/message_model.dart';
import '../../data/models/messages/multi_media_message_model.dart';
import '../../data/models/messages/text_message_model.dart';
import '../../data/models/messages/video_message_model.dart';

extension MessageModelHelpers on MessageModel {
  String getReplyMsgText() {
    String replyMsg = "";
    switch (type) {
      case MessageContentType.text:
        replyMsg = (this as TextMessageModel).text;
        break;

      case MessageContentType.image:
        replyMsg = LocaleKeys.MessagesPage_replyToImage.tr;
        break;
      case MessageContentType.video:
        replyMsg = LocaleKeys.MessagesPage_replyToVideo.tr;
        break;
      case MessageContentType.audio:
        replyMsg = LocaleKeys.MessagesPage_replyToAudio.tr;
        break;
      case MessageContentType.file:
        replyMsg = (this as FileMessageModel).metadata.name;
        break;
      case MessageContentType.call:
        replyMsg = "${(this as CallMessageModel).callType.name} Call";
        break;
      case MessageContentType.location:
        replyMsg = LocaleKeys.MessagesPage_replyToLocation.tr;
        break;
      case MessageContentType.liveLocation:
        replyMsg = LocaleKeys.MessagesPage_replyToLocation.tr;
        break;
      case MessageContentType.multiMedia:
        replyMsg = LocaleKeys.MessagesPage_replyToMultiMedia.tr;
        break;
    }

    return replyMsg;
  }
}
