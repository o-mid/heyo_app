import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/forward_massages/data/models/forward_massages_view_arguments_model..dart';
import 'package:heyo/app/modules/media_view/widgets/media_view_bottom_sheet.dart';
import 'package:heyo/app/modules/messages/data/models/messages/image_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/video_message_model.dart';
import 'package:heyo/app/modules/messages/widgets/body/video_message_player.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/assets.gen.dart';

import '../controllers/media_view_controller.dart';

class MediaViewView extends GetView<MediaViewController> {
  const MediaViewView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Freezy Squeezer", style: TEXTSTYLES.kHeaderMedium),
                  Text(controller.date.toString(), style: TEXTSTYLES.kBodyTag),
                ],
              )
            ],
          ),
          actions: [
            IconButton(
              // TODO: open forward button
              onPressed: () {
                Get.toNamed(Routes.FORWARD_MASSAGES,
                    arguments: ForwardMassagesArgumentsModel(
                      selectedMessages: controller.messages,
                    ));
              },
              icon: Assets.svg.forwardIcon.svg(
                color: Colors.white,
                width: 18.w,
              ),
            ),
            IconButton(
              // TODO: open bottomSheet
              onPressed: () {
                openMediaViewBottomSheet(controller.mediaList);
              },
              icon: Assets.svg.verticalMenuIcon.svg(
                height: 15.h,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Obx(() {
            print(controller.activeIndex);
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: controller.isVideo
                      ? Container(
                          color: Colors.black,
                          child: Center(
                            child: VideoMessagePlayer(
                              message: controller.currentMessage
                                  as VideoMessageModel,
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.black,
                          child: PhotoView(
                            imageProvider: ExtendedFileImageProvider(
                              File((controller.currentMessage
                                      as ImageMessageModel)
                                  .url),
                            ),
                            scaleStateController:
                                controller.photoViewcontroller,
                            minScale: PhotoViewComputedScale.contained * 1.0,
                          ),
                        ),
                ),
                Container(
                  color: Colors.black,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.mediaList.length,
                          itemBuilder: (BuildContext context, int index) {
                            bool isVideo = controller.mediaList[index].type ==
                                CONTENT_TYPE.VIDEO;

                            return GestureDetector(
                              onTap: () {
                                controller.photoViewcontroller.reset();
                                controller.setActiveMedia(index);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                    width: 40.w,
                                    height: 40.w,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                            color: index ==
                                                    controller.activeIndex.value
                                                ? COLORS.kGreenMainColor
                                                : COLORS.kGreenLighterColor,
                                            width: 2),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: Expanded(
                                            child: isVideo
                                                ? SizedBox(
                                                    width: 40.w,
                                                    height: 40.w,
                                                    child: Image.memory(
                                                      controller
                                                          .mediaList[index]
                                                          .metadata
                                                          .thumbnailBytes,
                                                      fit: BoxFit.cover,
                                                    ))
                                                : SizedBox(
                                                    width: 40.w,
                                                    height: 40.w,
                                                    child: Image.file(
                                                      File((controller.mediaList[
                                                                  index]
                                                              as ImageMessageModel)
                                                          .url),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )),
                                      ),
                                    )),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }),
        ));
  }
}
