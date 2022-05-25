import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_camera/flutter_camera.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/gallery_picker/widgets/current_path_selector.dart';
import 'package:heyo/app/modules/gallery_picker/widgets/gallery_grid_view.dart';
import 'package:heyo/app/modules/gallery_picker/widgets/media_preview_widget.dart';
import 'package:heyo/app/modules/gallery_picker/widgets/thumbnail_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/gallery_preview_button_widget.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:mime/mime.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/gallery_picker_controller.dart';

class GalleryPickerView extends GetView<GalleryPickerController> {
  const GalleryPickerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          actions: [
            _DropdownWidget(controller: controller),
          ],
        ),
        body: Column(
          children: [
            CustomSizes.smallSizedBoxHeight,

            /// grid view
            Expanded(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: AnimatedBuilder(
                    animation: controller.provider.currentPathNotifier,
                    builder: (BuildContext context, child) => GalleryGridView(
                      path: controller.provider.currentPath,
                      thumbnailQuality: 200,
                      provider: controller.provider,
                      childAspectRatio: 1,
                      crossAxisCount: 3,
                      gridViewBackgroundColor: Colors.black,
                      onAssetItemClick: (ctx, asset, index) async {
                        controller.provider.pickEntity(asset);

                        controller.getFile(asset).then((value) {
                          /// add metadata to map list
                          controller.provider.pickPath({
                            'id': asset.id,
                            'path': value,
                            'type': asset.typeInt == 1 ? 'image' : 'video',
                            'videoDuration': asset.videoDuration,
                            'createDateTime': asset.createDateTime,
                            'latitude': asset.latitude,
                            'longitude': asset.longitude,
                            'thumbnail': asset.thumbnailData,
                            'height': asset.height,
                            'width': asset.width,
                            'orientationHeight': asset.orientatedHeight,
                            'orientationWidth': asset.orientatedWidth,
                            'orientationSize': asset.orientatedSize,
                            'file': asset.file,
                            'modifiedDateTime': asset.modifiedDateTime,
                            'title': asset.title,
                            'size': asset.size,
                          });
                          controller
                              .setPickedfile(controller.provider.pickedFile);
                        });
                      },
                    ),
                  )),
            ),

            Container(
              width: double.infinity,
              color: Colors.black87,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: SizedBox(
                  height: 40.w,
                  child: Row(
                    children: [
                      MediaPreview(
                        controller: controller,
                      ),
                      IconButton(
                        // Todo: send Btn
                        onPressed: () {
                          String path = controller.previewFiles[0]['path'];
                          CameraPickerViewer.pushToViewer(
                            context,
                            pickerState: CameraPickerState(),
                            pickerType: controller.isAssetImage(path)
                                ? CameraPickerViewType.image
                                : CameraPickerViewType.video,
                            previewXFile: XFile(path),
                            theme: ThemeData(),
                            sendIcon: Assets.svg.sendIcon.svg(),
                            additionalPreviewButtonWidget:
                                const GalleryPreviewButtonWidget(),
                            previewTextInputDecoration: InputDecoration(
                              hintText: 'Type something',
                              hintStyle: TEXTSTYLES.kBodySmall
                                  .copyWith(color: COLORS.kTextSoftBlueColor),
                            ),
                            previewFiles: controller.pickedFile,
                            shouldShowItemCount: true,
                          );
                        },
                        icon: Assets.svg.sendImageIcon.svg(),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

class _DropdownWidget extends StatelessWidget {
  const _DropdownWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final GalleryPickerController controller;

  @override
  Widget build(BuildContext context) {
    /// album drop down
    return Container(
      color: Colors.black,
      alignment: Alignment.bottomLeft,
      child: SelectedPathDropdownButton(
        provider: controller.provider,
        appBarColor: Colors.black,
        appBarIconColor: const Color(0xFFB2B2B2),
        appBarTextColor: Colors.white,
        albumTextColor: Colors.white,
        albumDividerColor: const Color(0xFF484848),
        albumBackGroundColor: const Color(0xFF333333),
        appBarLeadingWidget: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 15, bottom: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 40,
                ),

                /// share
                GestureDetector(
                  onTap: () async {
                    controller.pickedFile.map((p) {
                      controller.mediaPath.add(p['path']);
                    }).toString();
                    if (controller.mediaPath.isNotEmpty) {
                      await Share.shareFiles(controller.mediaPath);
                    }
                    controller.mediaPath.clear();
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue, width: 1.5),
                    ),
                    child: Transform.scale(
                      scale: 2,
                      child: const Icon(
                        Icons.share_outlined,
                        color: Colors.blue,
                        size: 10,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
