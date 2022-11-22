import 'package:heyo/app/modules/messages/data/models/messages/audio_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/call_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/file_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/image_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/live_location_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/location_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/multi_media_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/text_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/video_message_model.dart';

MessageModel messageFromJson(Map<String, dynamic> json) {
  final typeString = json[MessageModel.typeSerializedName];

  final type = MessageContentType.values.byName(typeString);

  switch (type) {
    case MessageContentType.text:
      return TextMessageModel.fromJson(json);
    case MessageContentType.image:
      return ImageMessageModel.fromJson(json);
    case MessageContentType.video:
      return VideoMessageModel.fromJson(json);
    case MessageContentType.audio:
      return AudioMessageModel.fromJson(json);
    case MessageContentType.file:
      return FileMessageModel.fromJson(json);
    case MessageContentType.call:
      return CallMessageModel.fromJson(json);
    case MessageContentType.location:
      return LocationMessageModel.fromJson(json);
    case MessageContentType.liveLocation:
      return LiveLocationMessageModel.fromJson(json);
    case MessageContentType.multiMedia:
      return MultiMediaMessageModel.fromJson(json);
  }
}
