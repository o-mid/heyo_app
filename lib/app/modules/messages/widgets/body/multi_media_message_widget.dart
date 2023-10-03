import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/image_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/multi_media_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/video_message_model.dart';
import 'package:heyo/app/modules/shared/data/models/media_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/routes/app_pages.dart';

import 'video_message_player.dart';

class MultiMediaMessageWidget extends StatelessWidget {
  final MultiMediaMessageModel message;
  final int showMediaLimitCount;
  const MultiMediaMessageWidget({Key? key, required this.message, this.showMediaLimitCount = 6})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMoreThanLimit = message.mediaList.length > showMediaLimitCount;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 8.w,
        ),
        itemCount: isMoreThanLimit ? showMediaLimitCount : message.mediaList.length,
        itemBuilder: (context, index) {
          bool isMediaLocal;
          bool isMediaVideo = message.mediaList[index].type == MessageContentType.video;
          isMediaVideo
              ? isMediaLocal = (message.mediaList[index] as VideoMessageModel).metadata.isLocal
              : isMediaLocal = (message.mediaList[index] as ImageMessageModel).isLocal;
          return GestureDetector(
            onTap: () {
              Get.toNamed(Routes.MEDIA_VIEW,
                  arguments: MediaViewArgumentsModel(
                    mediaList: message.mediaList,
                    isMultiMessage: true,
                    multiMessage: message,
                    activeIndex: index,
                  ));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: SizedBox(
                width: 133.w,
                height: 133.w,
                child: isMoreThanLimit && index == showMediaLimitCount - 1
                    ? Stack(
                        alignment: Alignment.center,
                        fit: StackFit.passthrough,
                        children: [
                          ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                            child: isMediaVideo
                                ? (message.mediaList[index] as VideoMessageModel).metadata.isLocal
                                    ? Image.memory(
                                        (message.mediaList[index] as VideoMessageModel)
                                            .metadata
                                            .thumbnailBytes!,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        (message.mediaList[index] as VideoMessageModel)
                                            .metadata
                                            .thumbnailUrl,
                                        fit: BoxFit.cover,
                                      )
                                : isMediaLocal
                                    ? Image.file(
                                        File(message.mediaList[index].url.toString()),
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        message.mediaList[index].url.toString(),
                                      ),
                          ),
                          Center(
                            child: Text(
                              '+${message.mediaList.length - showMediaLimitCount}',
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
                            message: message.mediaList[index] as VideoMessageModel,
                            isMultiMessage: true,
                            multiMessageOnTap: () {
                              Get.toNamed(Routes.MEDIA_VIEW,
                                  arguments: MediaViewArgumentsModel(
                                    mediaList: message.mediaList,
                                    isMultiMessage: true,
                                    multiMessage: message,
                                    activeIndex: index,
                                  ));
                            },
                          )
                        : isMediaLocal
                            ? Image.file(
                                File(message.mediaList[index].url.toString()),
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                message.mediaList[index].url.toString(),
                                fit: BoxFit.cover,
                              ),
              ),
            ),
          );
        },
      ),
    );
  }
}
