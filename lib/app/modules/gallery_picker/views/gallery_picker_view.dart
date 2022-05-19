import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/gallery_picker/widgets/current_path_selector.dart';
import 'package:heyo/app/modules/gallery_picker/widgets/gallery_grid_view.dart';

import '../controllers/gallery_picker_controller.dart';

class GalleryPickerView extends GetView<GalleryPickerController> {
  @override
  Widget build(BuildContext context) {
    final key = GlobalKey();
    return Scaffold(
        appBar: AppBar(
          title: Text('GalleryPickerView'),
          centerTitle: true,
        ),
        body: Obx(() {
          return Column(
            children: [
              /// album drop down
              Center(
                child: Container(
                  color: Colors.black,
                  alignment: Alignment.bottomLeft,
                  height: 100,
                  child: SelectedPathDropdownButton(
                    dropdownRelativeKey: key,
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
                            /// select multiple / single
                            SizedBox(
                              height: 30,
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        controller.singlePick.value =
                                            !controller.singlePick.value;

                                        debugPrint(controller.singlePick.value
                                            .toString());
                                      },
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                              color: Colors.blue, width: 1.5),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                'Select multiple',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 10),
                                              ),
                                              const SizedBox(
                                                width: 7,
                                              ),
                                              Transform.scale(
                                                scale: 1.5,
                                                child: Icon(
                                                  controller.singlePick.value
                                                      ? Icons
                                                          .check_box_outline_blank
                                                      : Icons
                                                          .check_box_outlined,
                                                  color: Colors.blue,
                                                  size: 10,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 40,
                            ),

                            /// share
                            GestureDetector(
                              onTap: () async {
                                media.pickedFile.map((p) {
                                  setState(() {
                                    _mediaPath.add(p['path']);
                                  });
                                }).toString();
                                if (_mediaPath.isNotEmpty) {
                                  await Share.shareFiles(_mediaPath);
                                }
                                _mediaPath.clear();
                              },
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.blue, width: 1.5),
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
                ),
              ),

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
                        //padding: ,
                        childAspectRatio: 0.5,
                        crossAxisCount: 3,
                        // gridViewBackgroundColor: widget.gridViewBackgroundColor,
                        // gridViewController: widget.gridViewController,
                        //gridViewPhysics: widget.gridViewPhysics,
                        //  imageBackgroundColor: widget.imageBackgroundColor,
                        // selectedBackgroundColor: widget.selectedBackgroundColor,
                        // selectedCheckColor: widget.selectedCheckColor,
                        // thumbnailBoxFix: widget.thumbnailBoxFix,
                        // selectedCheckBackgroundColor:
                        //     widget.selectedCheckBackgroundColor,
                        onAssetItemClick: (ctx, asset, index) async {
                          controller.provider.pickEntity(asset);
                          _getFile(asset).then((value) {
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
                            widget.pathList!(controller.provider.pickedFile);
                          });
                        },
                      ),
                    )),
              )
            ],
          );
        }));
  }
}
