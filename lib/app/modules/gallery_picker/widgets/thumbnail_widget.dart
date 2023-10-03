import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:heyo/app/modules/gallery_picker/provider/gallery_provider.dart';
import 'package:heyo/app/modules/gallery_picker/widgets/decode_image.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:photo_manager/photo_manager.dart';

class ThumbnailWidget extends StatelessWidget {
  /// asset entity
  final AssetEntity asset;

  /// image quality thumbnail
  final int thumbnailQuality;

  /// background image color
  final Color imageBackgroundColor;

  /// image provider
  final PickerDataProvider provider;

  /// selected background color
  final Color selectedBackgroundColor;

  /// selected check color
  final Color selectedCheckColor;

  /// selected Check Background Color
  final Color selectedCheckBackgroundColor;

  final int index;

  /// thumbnail box fit
  final BoxFit thumbnailBoxFix;
  const ThumbnailWidget(
      {Key? key,
      required this.asset,
      required this.provider,
      required this.index,
      this.thumbnailQuality = 200,
      this.imageBackgroundColor = Colors.white,
      this.selectedBackgroundColor = Colors.white,
      this.selectedCheckColor = Colors.white,
      this.thumbnailBoxFix = BoxFit.cover,
      this.selectedCheckBackgroundColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        /// background gradient from image
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),

        /// thumbnail image
        FutureBuilder<Uint8List?>(
          future: asset.thumbnailData,
          builder: (_, data) {
            if (data.hasData) {
              return SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  child: Image(
                    image: DecodeImage(
                        provider.pathList[provider.pathList.indexOf(provider.currentPath!)],
                        thumbSize: thumbnailQuality,
                        index: index),
                    gaplessPlayback: true,
                    fit: thumbnailBoxFix,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),

        /// selected image color mask
        AnimatedBuilder(
            animation: provider,
            builder: (_, __) {
              final pickIndex = provider.pickIndex(asset);
              final picked = pickIndex >= 0;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: picked ? selectedBackgroundColor.withOpacity(0.3) : Colors.transparent,
                ),
              );
            }),

        /// selected image check
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 10),
            child: AnimatedBuilder(
                animation: provider,
                builder: (_, __) {
                  final pickIndex = provider.pickIndex(asset);
                  final picked = pickIndex >= 0;
                  return Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: picked ? COLORS.kGreenMainColor : Colors.transparent,
                      border: Border.all(
                          width: 1.5, color: picked ? COLORS.kGreenMainColor : Colors.white),
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: picked ? selectedCheckColor : Colors.transparent,
                      size: 14,
                    ),
                  );
                }),
          ),
        ),

        /// video duration widget
        if (asset.type == AssetType.video)
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 10),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: Text(
                    _parseDuration(asset.videoDuration.inSeconds) as String,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600, fontSize: 8),
                  )),
            ),
          )
      ],
    );
  }
}

/// parse second to duration
_parseDuration(int seconds) {
  if (seconds < 600) {
    return '${Duration(seconds: seconds)}'.toString().substring(3, 7);
  } else if (seconds > 600 && seconds < 3599) {
    return '${Duration(seconds: seconds)}'.toString().substring(2, 7);
  } else {
    return '${Duration(seconds: seconds)}'.toString().substring(1, 7);
  }
}
