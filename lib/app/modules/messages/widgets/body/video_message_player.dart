import 'dart:math';
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/video_message_model.dart';
import 'package:heyo/app/modules/shared/controllers/video_message_controller.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/generated/assets.gen.dart';

class VideoMessagePlayer extends GetView<VideoMessageController> {
  final VideoMessageModel message;
  final bool isMultiMessage;
  final VoidCallback? multiMessageOnTap;
  const VideoMessagePlayer({
    Key? key,
    required this.message,
    this.isMultiMessage = false,
    this.multiMessageOnTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isActive = controller.playingId.value == message.messageId;
      final chewieController = controller.chewieController;
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: isActive &&
                chewieController != null &&
                chewieController.videoPlayerController.value.isInitialized &&
                !isMultiMessage
            ? AspectRatio(
                aspectRatio: isMultiMessage
                    ? 1.0
                    : chewieController.videoPlayerController.value.aspectRatio,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Chewie(
                    controller: chewieController,
                  ),
                ),
              )
            : _VideoThumbnail(
                thumbnailUrl: message.metadata.thumbnailUrl,
                onTap: () => isMultiMessage
                    ? multiMessageOnTap!()
                    : controller.initializePlayer(message),
                isLoading: isActive,
                mWidth: message.metadata.width,
                mHeight: message.metadata.height,
                isLocal: message.metadata.isLocal,
                imageBytes: message.metadata.thumbnailBytes,
                isMultiMessage: isMultiMessage,
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
  final bool isMultiMessage;
  final bool isLocal;
  Uint8List? imageBytes;
  _VideoThumbnail({
    Key? key,
    required this.thumbnailUrl,
    required this.mWidth,
    required this.mHeight,
    required this.isLocal,
    this.imageBytes,
    this.isMultiMessage = false,
    this.onTap,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = min(mWidth, constraints.maxWidth);
      final height = width * (mHeight / mWidth);
      return SizedBox(
        width: isMultiMessage ? constraints.maxWidth : width,
        height: isMultiMessage ? constraints.maxHeight : height,
        child: Container(
          color: isMultiMessage ? COLORS.kBrightBlueColor : Colors.transparent,
          child: GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  isLocal
                      ? ExtendedImage.memory(
                          imageBytes!,
                        )
                      : ExtendedImage.network(
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
                    child: isLoading && !isMultiMessage
                        ? const CircularProgressIndicator(
                            color: COLORS.kWhiteColor)
                        : Assets.svg.playIcon.svg(
                            color: COLORS.kWhiteColor,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
