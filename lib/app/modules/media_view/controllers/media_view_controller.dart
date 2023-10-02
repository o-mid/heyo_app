import 'dart:typed_data';

import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/media_view/widgets/media_view_bottom_sheet_widget.dart';
import 'package:heyo/app/modules/messages/data/models/messages/multi_media_message_model.dart';
import 'package:heyo/app/modules/shared/data/models/media_view_arguments_model.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

import '../../messages/data/models/messages/message_model.dart';

class MediaViewController extends GetxController {
  PhotoViewScaleStateController photoViewController;
  MediaViewController({
    required this.photoViewController,
  });
  late MediaViewArgumentsModel args;
  late List<dynamic> mediaList;

  Rx<int> activeIndex = 0.obs;
  MultiMediaMessageModel? multiMessage;
  late bool isMultiMessage;
  List<MessageModel> messages = [];
  late MessageModel currentMessage;
  Uint8List? currentVideoThumbnail;
  RxString name = "".obs;

  late bool isVideo;
  String? date;

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
      messages.add(args.mediaList.first as MessageModel);
    }
    date = DateFormat('MM/dd/yyyy, H:mm').format(mediaList.first.timestamp as DateTime);
    name.value = mediaList.first.senderName as String ?? "";
    currentMessage = mediaList[activeIndex.value] as MessageModel;
    currentMessage.type == MessageContentType.video ? isVideo = true : isVideo = false;
    photoViewController = PhotoViewScaleStateController();
    super.onInit();
  }

  void setActiveMediaAndResetController(int index) {
    photoViewController.reset();
    activeIndex.value = index;
    currentMessage = mediaList[activeIndex.value] as MessageModel;
    currentMessage.type == MessageContentType.video ? isVideo = true : isVideo = false;
  }

  @override
  void onClose() {
    photoViewController.dispose();
    super.onClose();
  }

  List<String> paths = [];
  Future<void> _saveVideo(String path) async {
    await GallerySaver.saveVideo(path).then((value) {
      print(value);
    });
  }

  Future<void> _saveImage(String path) async {
    await GallerySaver.saveImage(path).then((value) {
      print(value);
    });
  }

  Future<void> saveFiles() async {
    if (paths.isEmpty) {
      for (var message in mediaList) {
        bool isVideo = message.type == MessageContentType.video;
        if (isVideo) {
          paths.add(message.url as String);
          await _saveVideo(message.url as String);
        } else {
          paths.add(message.url as String);
          await _saveImage(message.url as String);
        }
      }
    }
  }

  void saveAndShareFiles() {
    saveFiles();
    Share.shareFiles(paths);
  }

  void openBottomSheet() {
    openMediaViewBottomSheet();
  }
}
