import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_camera/flutter_camera.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/gallery_picker/controllers/gallery_picker_controller.dart';

class MediaPreview extends StatelessWidget {
  const MediaPreview({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final GalleryPickerController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: controller.previewFiles.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: (GestureDetector(
                onTap: () {
                  String path = controller.previewFiles[index]['path'];
                  CameraPickerViewer.pushToViewer(
                    context,
                    pickerState: CameraPickerState(),
                    pickerType: controller.isAssetImage(path)
                        ? CameraPickerViewType.image
                        : CameraPickerViewType.video,
                    previewXFile: XFile(path),
                    theme: ThemeData(),
                  );
                },
                child: SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: Image.file(
                      File(controller.previewFiles[index]['path']),
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.white,
                        child: const Icon(
                          Icons.play_circle_fill_rounded,
                          color: Colors.black,
                          size: 38,
                        ),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )),
            );
          },
        ),
      );
    });
  }
}
