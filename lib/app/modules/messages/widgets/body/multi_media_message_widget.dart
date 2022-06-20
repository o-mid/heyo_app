import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/image_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/multi_media_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/video_message_model.dart';
import 'package:heyo/app/modules/shared/data/models/media_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/routes/app_pages.dart';

import 'video_message_player.dart';

class MultiMediaMessageWidget extends StatelessWidget {
  final MultiMediaMessageModel message;
  const MultiMediaMessageWidget({Key? key, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMoreThanSix = message.mediaList.length > 6;

    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.w,
      ),
      itemCount: isMoreThanSix ? 6 : message.mediaList.length,
      itemBuilder: (context, index) {
        bool isMediaLocal;
        bool isMediaVideo =
            message.mediaList[index].type == 'CONTENT_TYPE.VIDEO';
        isMediaVideo
            ? isMediaLocal = message.mediaList[index].metadata.isLocal
            : isMediaLocal = true;
        return GestureDetector(
          onTap: () {
            Get.toNamed(Routes.MEDIA_VIEW,
                arguments: MediaViewArgumentsModel(
                  mediaList: message.mediaList,
                  activeIndex: index,
                ));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: SizedBox(
              width: 133.w,
              height: 133.w,
              child: isMoreThanSix && index == 5
                  ? Stack(
                      alignment: Alignment.center,
                      fit: StackFit.passthrough,
                      children: [
                        ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                          child: isMediaLocal
                              ? ExtendedImage.file(
                                  File(message.mediaList[index].url),
                                  fit: BoxFit.cover,
                                )
                              : ExtendedImage.network(
                                  message.mediaList[index].url),
                        ),
                        Center(
                          child: Text(
                            '+${message.mediaList.length - 6}',
                            style: TEXTSTYLES.kHeaderDisplay.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    )
                  : isMediaVideo
                      ? VideoMessagePlayer(
                          message: message.mediaList[index],
                        )
                      : isMediaLocal
                          ? ExtendedImage.file(
                              File(message.mediaList[index].url),
                              fit: BoxFit.cover,
                            )
                          : ExtendedImage.network(message.mediaList[index].url),
            ),
          ),
        );
      },
    );
  }
}
