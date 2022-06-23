import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/multi_media_message_model.dart';
import 'package:heyo/app/modules/shared/data/models/media_view_arguments_model.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';

import '../../messages/data/models/messages/image_message_model.dart';
import '../../messages/data/models/messages/message_model.dart';

class MediaViewController extends GetxController {
  late MediaViewArgumentsModel args;
  late List<dynamic> mediaList;
  late PhotoViewScaleStateController photoViewcontroller;

  Rx<int> activeIndex = 0.obs;
  MultiMediaMessageModel? multiMessage;
  late bool isMultiMessage;
  List<MessageModel> messages = [];
  late MessageModel currentMessage;
  Uint8List? currentVideoThumbnail;

  late bool isVideo;
  String? date;

  final count = 0.obs;
  @override
  void onInit() {
    args = Get.arguments as MediaViewArgumentsModel;
    mediaList = args.mediaList;
    activeIndex.value = args.activeIndex;
    multiMessage = args.multiMessage;
    isMultiMessage = args.isMultiMessage;
    if (isMultiMessage) {
      messages.add(multiMessage!);
    } else {
      messages.add(args.mediaList.first);
    }
    date = DateFormat('MM/dd/yyyy, H:mm').format(mediaList.first.timestamp);
    currentMessage = mediaList[activeIndex.value];
    currentMessage.type == CONTENT_TYPE.VIDEO
        ? isVideo = true
        : isVideo = false;
    photoViewcontroller = PhotoViewScaleStateController();
    super.onInit();
  }

  void setActiveMedia(int index) {
    activeIndex.value = index;
    currentMessage = mediaList[activeIndex.value];
    currentMessage.type == CONTENT_TYPE.VIDEO
        ? isVideo = true
        : isVideo = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    photoViewcontroller.dispose();
    super.onClose();
  }

  void increment() => count.value++;
}
