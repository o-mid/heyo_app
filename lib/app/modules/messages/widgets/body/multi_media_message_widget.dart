import 'dart:io';
import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/messages/data/models/messages/image_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/multi_media_message_model.dart';

class MultiMediaMessageWidget extends StatelessWidget {
  final MultiMediaMessageModel message;
  const MultiMediaMessageWidget({Key? key, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemCount: message.mediaList.length,
          itemBuilder: (context, index) {
            return Container(
              color: Colors.lightGreen,
              width: 50,
              height: 50,
              child: Image.file(
                File(message.mediaList[index].url),
              ),
            );
            // return LayoutBuilder(builder: (context, constraints) {
            //   final mWidth = (message.mediaList[index]).metadata.width;
            //   final mHeight = (message.mediaList[index]).metadata.height;
            //   final width = min(mWidth, constraints.maxWidth);
            //   final height = width * (mHeight / mWidth);
            //   return SizedBox(
            //     width: width,
            //     height: height,
            //     child: ClipRRect(
            //       borderRadius: BorderRadius.circular(8.r),
            //       child: (message as ImageMessageModel).isLocal
            //           ? ExtendedImage.file(
            //               File((message as ImageMessageModel).url))
            //           : ExtendedImage.network(
            //               (message as ImageMessageModel).url),
            //     ),
            //   );
            // });
          }),
    );
  }
}
