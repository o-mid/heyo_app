import 'dart:math';

import 'package:chewie/chewie.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/video_message_model.dart';
import 'package:heyo/app/modules/shared/data/controllers/video_message_controller.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/generated/assets.gen.dart';

class VideoMessagePlayer extends GetView<VideoMessageController> {
  final VideoMessageModel message;
  const VideoMessagePlayer({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isActive = controller.playingId.value == message.messageId;
      final chewieController = controller.chewieController;
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: isActive &&
                chewieController != null &&
                chewieController.videoPlayerController.value.isInitialized
            ? AspectRatio(
                aspectRatio: chewieController.videoPlayerController.value.aspectRatio,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Chewie(
                    controller: chewieController,
                  ),
                ),
              )
            : _VideoThumbnail(
                thumbnailUrl: message.metadata.thumbnailUrl,
                onTap: () => controller.initializePlayer(message),
                isLoading: isActive,
                mWidth: message.metadata.width,
                mHeight: message.metadata.height,
              ),
      );
    });
  }
}

class _VideoThumbnail extends StatelessWidget {
  final String thumbnailUrl;
  final double mWidth;
  final double mHeight;
  final VoidCallback? onTap;
  final bool isLoading;
  const _VideoThumbnail({
    Key? key,
    required this.thumbnailUrl,
    required this.mWidth,
    required this.mHeight,
    this.onTap,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = min(mWidth, constraints.maxWidth);
      final height = width * (mHeight / mWidth);
      return SizedBox(
        width: width,
        height: height,
        child: GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ExtendedImage.network(
                  thumbnailUrl,
                ),
                Container(
                  width: 40.h,
                  height: 40.h,
                  padding: EdgeInsets.all(14.h),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: COLORS.kBlackColor.withOpacity(0.5),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: COLORS.kWhiteColor)
                      : Assets.svg.playIcon.svg(
                          color: COLORS.kWhiteColor,
                        ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
