import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:heyo/app/modules/share_files/models/file_model.dart';
import 'package:heyo/app/modules/share_files/widgets/file_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/inputs/custom_text_field.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

import '../controllers/share_files_controller.dart';

class ShareFilesView extends GetView<ShareFilesController> {
  const ShareFilesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: COLORS.kGreenMainColor,
          elevation: 0,
          centerTitle: false,
          title: Text(
            LocaleKeys.newChat_newChatAppBar.tr,
            style: const TextStyle(
              fontWeight: FONTS.Bold,
              fontFamily: FONTS.interFamily,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Assets.svg.searchIcon.svg(),
            ),
            IconButton(
                onPressed: () {
                  controller.pickFiles();
                },
                icon: Assets.svg.folderIcon.svg(
                  width: 5,
                )),
          ],
          automaticallyImplyLeading: true,
        ),
        body: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomSizes.smallSizedBoxHeight,
              Padding(
                padding: CustomSizes.contentPaddingWidth,
                child: Column(
                  children: [
                    CustomSizes.largeSizedBoxHeight,
                    CUSTOMTEXTFIELD(
                      textController: controller.inputController,
                      labelText: LocaleKeys.shareFilePage_textInputTitle.tr,
                      rightWidget: InkWell(
                        onTap: () {
                          controller.inputController.clear();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Assets.svg.closeSign
                              .svg(color: COLORS.kDarkBlueColor),
                        ),
                      ),
                    ),
                    CustomSizes.largeSizedBoxHeight,
                  ],
                ),
              ),
              const Divider(
                color: COLORS.kMessagingDividerColor,
                thickness: 8,
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.resetFiles.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FileWidget(
                      file: controller.resetFiles[index],
                      onTap: () {},
                    );
                  },
                ),
              )
            ],
          );
        }));
  }
}
