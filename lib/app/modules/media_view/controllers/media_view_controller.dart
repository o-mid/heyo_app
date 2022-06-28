import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/multi_media_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/video_message_model.dart';
import 'package:heyo/app/modules/shared/data/models/media_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

import '../../messages/data/models/messages/image_message_model.dart';
import '../../messages/data/models/messages/message_model.dart';

class MediaViewController extends GetxController {
  PhotoViewScaleStateController photoViewcontroller;
  MediaViewController({
    required this.photoViewcontroller,
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
      messages.add(args.mediaList.first);
    }
    date = DateFormat('MM/dd/yyyy, H:mm').format(mediaList.first.timestamp);
    name.value = mediaList.first.senderName ?? "";
    currentMessage = mediaList[activeIndex.value];
    currentMessage.type == CONTENT_TYPE.VIDEO
        ? isVideo = true
        : isVideo = false;
    photoViewcontroller = PhotoViewScaleStateController();
    super.onInit();
  }

  void setActiveMediaAndResetController(int index) {
    photoViewcontroller.reset();
    activeIndex.value = index;
    currentMessage = mediaList[activeIndex.value];
    currentMessage.type == CONTENT_TYPE.VIDEO
        ? isVideo = true
        : isVideo = false;
  }

  @override
  void onClose() {
    photoViewcontroller.dispose();
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
        bool isVideo = message.type == CONTENT_TYPE.VIDEO;
        if (isVideo) {
          paths.add(message.url);
          await _saveVideo(message.url);
        } else {
          paths.add(message.url);
          await _saveImage(message.url);
        }
      }
    }
  }

  void saveAndShareFiles() {
    saveFiles();
    Share.shareFiles(paths);
  }

  void openMediaViewBottomSheet() {
    Get.bottomSheet(
      backgroundColor: COLORS.kWhiteColor,
      isDismissible: true,
      persistent: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      Padding(
        padding: CustomSizes.mainContentPadding,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomSizes.smallSizedBoxHeight,
              TextButton(
                  //Todo: editIcon onPressed
                  onPressed: () {},
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: COLORS.kBrightBlueColor,
                          ),
                          child: Assets.svg.editIcon.svg(
                              width: 20,
                              height: 20,
                              color: COLORS.kDarkBlueColor),
                        ),
                      ),
                      CustomSizes.mediumSizedBoxWidth,
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            LocaleKeys.mediaView_bottomSheet_edit.tr,
                            style: TEXTSTYLES.kBodyBasic.copyWith(
                              color: COLORS.kDarkBlueColor,
                              fontWeight: FONTS.Medium,
                            ),
                          ))
                    ],
                  )),
              TextButton(
                  //Media and files onPressed
                  onPressed: () {},
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: COLORS.kBrightBlueColor,
                          ),
                          child: Assets.svg.mediaAndFilesIcon.svg(
                              width: 20,
                              height: 20,
                              color: COLORS.kDarkBlueColor),
                        ),
                      ),
                      CustomSizes.mediumSizedBoxWidth,
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            LocaleKeys.mediaView_bottomSheet_mediafiles.tr,
                            style: TEXTSTYLES.kBodyBasic.copyWith(
                              color: COLORS.kDarkBlueColor,
                              fontWeight: FONTS.Medium,
                            ),
                          ))
                    ],
                  )),
              TextButton(
                  onPressed: () => saveAndShareFiles(),
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: COLORS.kBrightBlueColor,
                          ),
                          child: Assets.svg.shareIcon.svg(
                              width: 20,
                              height: 20,
                              color: COLORS.kDarkBlueColor),
                        ),
                      ),
                      CustomSizes.mediumSizedBoxWidth,
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            LocaleKeys.mediaView_bottomSheet_share.tr,
                            style: TEXTSTYLES.kBodyBasic.copyWith(
                              color: COLORS.kDarkBlueColor,
                              fontWeight: FONTS.Medium,
                            ),
                          ))
                    ],
                  )),
              TextButton(
                  onPressed: () => saveFiles(),
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: COLORS.kBrightBlueColor,
                          ),
                          child: Assets.svg.saveToDevice.svg(
                              width: 20,
                              height: 20,
                              color: COLORS.kDarkBlueColor),
                        ),
                      ),
                      CustomSizes.mediumSizedBoxWidth,
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            LocaleKeys.mediaView_bottomSheet_save.tr,
                            style: TEXTSTYLES.kBodyBasic.copyWith(
                              color: COLORS.kDarkBlueColor,
                              fontWeight: FONTS.Medium,
                            ),
                          ))
                    ],
                  )),
              TextButton(
                  //Todo: delete onPressed
                  onPressed: () {},
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: COLORS.kBrightBlueColor,
                          ),
                          child: Assets.svg.deleteIcon.svg(
                              width: 20,
                              height: 20,
                              color: COLORS.kDarkBlueColor),
                        ),
                      ),
                      CustomSizes.mediumSizedBoxWidth,
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            LocaleKeys.mediaView_bottomSheet_delete.tr,
                            style: TEXTSTYLES.kBodyBasic.copyWith(
                              color: COLORS.kDarkBlueColor,
                              fontWeight: FONTS.Medium,
                            ),
                          ))
                    ],
                  )),
            ]),
      ),
    );
  }
}
