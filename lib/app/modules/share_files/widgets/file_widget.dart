import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/share_files/models/file_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:intl/intl.dart';

class FileWidget extends StatelessWidget {
  final FileModel file;
  final void Function()? onTap;
  final void Function()? onLongPress;

  const FileWidget({
    Key? key,
    required this.file,
    required this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String displyTime = "";
    if (file.timestamp.difference(DateTime.now()).inDays >= 1) {
      displyTime = DateFormat('M/d/yy').format(file.timestamp);
    } else {
      displyTime = DateFormat('H:mm').format(file.timestamp);
    }
    return GestureDetector(
        onLongPress: onLongPress,
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: CustomSizes.userListPadding,
              child: Row(
                children: [
                  SizedBox(
                    height: 32,
                    width: 32,
                    child: file.isImage
                        ? Image.file(
                            File(file.path),
                            alignment: Alignment.center,
                            fit: BoxFit.cover,
                          )
                        : Stack(
                            alignment: Alignment.center,
                            children: [
                              file.extension == "pdf"
                                  ? Assets.svg.pdfIcon.svg()
                                  : file.extension == "mp3"
                                      ? Assets.svg.mp3Icon.svg()
                                      : file.extension == "pptx"
                                          ? Assets.svg.pptxIcon.svg()
                                          : Assets.svg.docIcon.svg(),
                              SizedBox(
                                  width: 32,
                                  child: Text(
                                    file.extension,
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
                          file.name,
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: COLORS.kDarkBlueColor,
                              overflow: TextOverflow.clip,
                              fontFamily: FONTS.interFamily,
                              fontWeight: FONTS.SemiBold),
                        ),
                        Text(
                          file.size,
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        displyTime,
                        style: TextStyle(
                          fontFamily: FONTS.interFamily,
                          fontWeight: FONTS.Medium,
                          fontSize: 10.sp,
                          color: COLORS.kTextSoftBlueColor,
                        ),
                      ),
                      Checkbox(
                          activeColor: COLORS.kGreenMainColor,
                          shape: const CircleBorder(),
                          value: file.isSelected,
                          onChanged: (v) {
                            onLongPress!();
                          }),
                    ],
                  )
                ],
              ),
            ),
            const Divider(
              color: COLORS.kBrightBlueColor,
              thickness: 2,
            )
          ],
        ));
  }
}
