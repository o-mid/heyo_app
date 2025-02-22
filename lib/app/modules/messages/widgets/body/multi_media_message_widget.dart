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

  const MultiMediaMessageWidget({
    Key? key,
    required this.message,
    this.showMediaLimitCount = 6,
  }) : super(key: key);

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
          final content = message.mediaList[index];
          return GestureDetector(
            onTap: () => _handleMediaTap(index),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: SizedBox(
                width: 133.w,
                height: 133.w,
                child: isMoreThanLimit && index == showMediaLimitCount - 1
                    ? _buildMoreOverlay(content)
                    : _buildMediaContent(content),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleMediaTap(int index) {
    Get.toNamed(Routes.MEDIA_VIEW,
        arguments: MediaViewArgumentsModel(
          mediaList: message.mediaList,
          isMultiMessage: true,
          multiMessage: message,
          activeIndex: index,
        ));
  }

  Widget _buildMoreOverlay(dynamic content) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.passthrough,
      children: [
        _buildBlurredMediaBackground(content),
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
    );
  }

  Widget _buildBlurredMediaBackground(dynamic content) {
    if (content.type == MessageContentType.video) {
      final videoContent = content as VideoMessageModel;
      return videoContent.metadata.isLocal
          ? Image.memory(
              videoContent.metadata.thumbnailBytes!,
              fit: BoxFit.cover,
            )
          : Image.network(
              videoContent.metadata.thumbnailUrl,
              fit: BoxFit.cover,
            );
    } else {
      return (content as ImageMessageModel).isLocal
          ? Image.file(File(content.url), fit: BoxFit.cover)
          : Image.network(content.url);
    }
  }

  Widget _buildMediaContent(dynamic content) {
    if (content.type == MessageContentType.video) {
      return VideoMessagePlayer(
        message: content as VideoMessageModel,
        isMultiMessage: true,
        multiMessageOnTap: () => _handleMediaTap(message.mediaList.indexOf(content)),
      );
    } else {
      return (content as ImageMessageModel).isLocal
          ? Image.file(File(content.url), fit: BoxFit.cover)
          : Image.network(content.url, fit: BoxFit.cover);
    }
  }
}
