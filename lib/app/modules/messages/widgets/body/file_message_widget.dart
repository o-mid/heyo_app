import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/messages/data/models/messages/file_message_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:open_file/open_file.dart';

class FileMessageWidget extends StatelessWidget {
  final FileMessageModel message;
  const FileMessageWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.ltr,
        child: GestureDetector(
          onTap: () {
            OpenFile.open(message.metadata.path);
          },
          child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                border: Border.all(color: COLORS.kPinCodeDeactivateColor),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 32,
                        width: 32,
                        child: message.metadata.isImage
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: Image.file(
                                  File(message.metadata.path),
                                  alignment: Alignment.center,
                                  fit: BoxFit.cover,
                                ))
                            : Stack(
                                alignment: Alignment.center,
                                children: [
                                  message.metadata.extension == "pdf"
                                      ? Assets.svg.pdfIcon.svg()
                                      : message.metadata.extension == "mp3"
                                          ? Assets.svg.mp3Icon.svg()
                                          : message.metadata.extension == "pptx"
                                              ? Assets.svg.pptxIcon.svg()
                                              : Assets.svg.docIcon.svg(),
                                  SizedBox(
                                      width: 32,
                                      child: Text(
                                        message.metadata.extension,
                                        textAlign: TextAlign.center,
                                        style: TEXTSTYLES.kBodyTag.copyWith(
                                            color: Colors.white,
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold),
                                      ))
                                ],
                              ),
                      ),
                      CustomSizes.mediumSizedBoxWidth,
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.metadata.name,
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  color: COLORS.kDarkBlueColor,
                                  overflow: TextOverflow.clip,
                                  fontFamily: FONTS.interFamily,
                                  fontWeight: FONTS.SemiBold),
                            ),
                            Text(
                              message.metadata.size,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TEXTSTYLES.kBodySmall.copyWith(
                                color: COLORS.kTextBlueColor,
                                fontWeight: FONTS.Light,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ));
  }
}
