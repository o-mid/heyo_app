import 'package:heyo/app/modules/messages/data/models/messages/multi_media_message_model.dart';

class MediaViewArgumentsModel {
  final List<dynamic> mediaList;
  final MultiMediaMessageModel? multiMessage;
  final bool isMultiMessage;
  final int activeIndex;

  MediaViewArgumentsModel(
      {required this.mediaList,
      required this.activeIndex,
      this.multiMessage,
      required this.isMultiMessage});
}
