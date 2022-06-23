import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/image_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/video_message_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:share_plus/share_plus.dart';

void openMediaViewBottomSheet(List<dynamic> mediaList) {
  List<String> paths = [];
  void _saveVideo(String path) async {
    await GallerySaver.saveVideo(path).then((value) {
      print(value);
    });
  }

  void _saveImage(String path) async {
    await GallerySaver.saveImage(path).then((value) {
      print(value);
    });
  }

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
                onPressed: () {
                  if (paths.isEmpty) {
                    for (var message in mediaList) {
                      bool isVideo = message.type == CONTENT_TYPE.VIDEO;
                      bool isLocal = true;
                      //Todo : Implement SAVE TO GALLERY FOR NOT LOCAL MEDIA
                      if (isVideo) {
                        isLocal =
                            (message as VideoMessageModel).metadata.isLocal;
                        isLocal
                            ? paths.add(message.url)
                            : _saveVideo(message.url);
                      } else {
                        isLocal = (message as ImageMessageModel).isLocal;
                        isLocal
                            ? paths.add(message.url)
                            : _saveImage(message.url);
                      }
                    }
                  }
                  Share.shareFiles(paths);
                },
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
                //Todo: savw onPressed
                onPressed: () {
                  if (paths.isEmpty) {
                    for (var message in mediaList) {
                      bool isVideo = message.type == CONTENT_TYPE.VIDEO;

                      if (isVideo) {
                        paths.add(message.url);
                        _saveVideo(message.url);
                      } else {
                        paths.add(message.url);
                        _saveImage(message.url);
                      }
                    }
                  }
                },
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
