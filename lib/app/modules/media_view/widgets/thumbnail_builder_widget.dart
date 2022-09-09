import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/media_view/controllers/media_view_controller.dart';
import 'package:heyo/app/modules/messages/data/models/messages/image_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/video_message_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';

class ThumbnailBuilderWidget extends StatelessWidget {
  const ThumbnailBuilderWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final MediaViewController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                bool isVideo =
                    controller.mediaList[index].type == MessageContentType.video;

                return GestureDetector(
                  onTap: () =>
                      controller.setActiveMediaAndResetController(index),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        width: 40.w,
                        height: 40.w,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                color: index == controller.activeIndex.value
                                    ? COLORS.kGreenMainColor
                                    : COLORS.kGreenLighterColor,
                                width: 2),
                          ),
                          child: Expanded(
                              child: isVideo
                                  ? SizedBox(
                                      width: 40.w,
                                      height: 40.w,
                                      child: (controller.mediaList[index]
                                                  as VideoMessageModel)
                                              .metadata
                                              .isLocal
                                          ? Image.memory(
                                              (controller.mediaList[index]
                                                      as VideoMessageModel)
                                                  .metadata
                                                  .thumbnailBytes!,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              (controller.mediaList[index]
                                                      as VideoMessageModel)
                                                  .metadata
                                                  .thumbnailUrl,
                                              fit: BoxFit.cover,
                                            ))
                                  : SizedBox(
                                      width: 40.w,
                                      height: 40.w,
                                      child: (controller.mediaList[index]
                                                  as ImageMessageModel)
                                              .isLocal
                                          ? Image.file(
                                              File((controller.mediaList[index]
                                                      as ImageMessageModel)
                                                  .url),
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              (controller.mediaList[index]
                                                      as ImageMessageModel)
                                                  .url,
                                              fit: BoxFit.cover,
                                            ),
                                    )),
                        )),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
