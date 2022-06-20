import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/forward_massages/data/models/forward_massages_view_arguments_model..dart';
import 'package:heyo/app/modules/media_view/widgets/media_view_bottom_sheet.dart';
import 'package:heyo/app/modules/messages/data/models/messages/image_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/video_message_model.dart';
import 'package:heyo/app/modules/messages/widgets/body/video_message_player.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
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
                openMediaViewBottomSheet();
              },
              icon: Assets.svg.verticalMenuIcon.svg(
                height: 15.h,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            controller.isVideo
                ? Expanded(
                    child: Center(
                      child: VideoMessagePlayer(
                        message: controller.currentMessage as VideoMessageModel,
                      ),
                    ),
                  )
                : Expanded(
                    child: Image.file(
                      File(
                          (controller.currentMessage as ImageMessageModel).url),
                      fit: BoxFit.cover,
                    ),
                  )
          ],
        ));
  }
}
