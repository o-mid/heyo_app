import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/share_files/controllers/share_files_controller.dart';
import 'package:heyo/app/modules/share_files/widgets/file_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/inputs/custom_text_field.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class ShareFilesView extends GetView<ShareFilesController> {
  const ShareFilesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
              onPressed: () {
                controller.showSearchBar.value =
                    !controller.showSearchBar.value;
              },
              icon: Assets.svg.searchIcon.svg(),
            ),
            IconButton(
              onPressed: () {
                controller.pickFiles();
              },
              icon: Assets.svg.folderIcon.svg(),
            ),
          ],
          automaticallyImplyLeading: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            controller.showSearchBar.value
                ? Column(
                    children: [
                      CustomSizes.smallSizedBoxHeight,
                      Padding(
                        padding: CustomSizes.contentPaddingWidth,
                        child: Column(
                          children: [
                            CustomSizes.largeSizedBoxHeight,
                            Focus(
                              onFocusChange: (focus) =>
                                  controller.isTextInputFocused.value = focus,
                              child: CustomTextField(
                                textController: controller.inputController,
                                labelText:
                                    LocaleKeys.shareFilePage_textInputTitle.tr,
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
                            ),
                            CustomSizes.largeSizedBoxHeight,
                          ],
                        ),
                      ),
                      const Divider(
                        color: COLORS.kBrightBlueColor,
                        thickness: 8,
                      ),
                    ],
                  )
                : const SizedBox(),
            CustomSizes.largeSizedBoxHeight,
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: CustomSizes.contentPaddingWidth,
                child: Text(
                  controller.showSearchBar.value
                      ? LocaleKeys.shareFilePage_searchResults.tr
                      : LocaleKeys.shareFilePage_mostRecent.tr,
                  style: TEXTSTYLES.kLinkSmall.copyWith(
                    color: COLORS.kTextBlueColor,
                  ),
                ),
              ),
            ),
            CustomSizes.smallSizedBoxHeight,
            Expanded(
              child: controller.isTextInputFocused.value
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.searchSuggestions.length,
                      itemBuilder: (BuildContext context, int index) {
                        return FileWidget(
                          file: controller.searchSuggestions[index],
                          onLongPress: () {
                            controller.addSelectedFile(
                                controller.searchSuggestions[index]);
                          },
                          onTap: () {
                            controller.openFile(
                                controller.searchSuggestions[index].path);
                          },
                        );
                      },
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.recentFiles.length,
                      itemBuilder: (BuildContext context, int index) {
                        return FileWidget(
                          file: controller.recentFiles[index],
                          onLongPress: () {
                            controller
                                .addSelectedFile(controller.recentFiles[index]);
                          },
                          onTap: () {
                            controller.openFile(
                              controller.recentFiles[index].path,
                            );
                          },
                        );
                      },
                    ),
            ),
            const Divider(
              color: COLORS.kBrightBlueColor,
              thickness: 4,
            ),
            Padding(
              padding: CustomSizes.contentPaddingWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("${controller.selectedFiles.length}",
                      style: TEXTSTYLES.kBodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: COLORS.kGreenMainColor)),
                  IconButton(
                    onPressed: () {
                      controller.sendSelectedFiles(
                        controller.selectedFiles,
                      );
                    },
                    icon: Assets.svg.sendIcon.svg(),
                  )
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
