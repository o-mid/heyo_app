import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/inputs/custom_text_field.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';

import '../../../../generated/locales.g.dart';
import '../../new_chat/widgets/user_widget.dart';
import '../../shared/widgets/list_header_widget.dart';
import '../controllers/forward_massages_controller.dart';

class ForwardMassagesView extends GetView<ForwardMassagesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          LocaleKeys.forwardMassagesPage_appbar.tr,
          style: TEXTSTYLES.kHeaderLarge.copyWith(color: COLORS.kWhiteColor),
        ),
        leading: IconButton(
          onPressed: (() => Get.back()),
          icon: const Icon(
            Icons.arrow_back,
            color: COLORS.kWhiteColor,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: true,
        backgroundColor: COLORS.kGreenMainColor,
      ),
      backgroundColor: COLORS.kWhiteColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    CustomSizes.largeSizedBoxHeight,
                    Padding(
                      padding: CustomSizes.contentPaddingWidth,
                      child: FocusScope(
                        child: Focus(
                          onFocusChange: (focus) =>
                              controller.isTextInputFocused.value = focus,
                          child: CUSTOMTEXTFIELD(
                            textController: controller.inputController,
                            labelText:
                                LocaleKeys.forwardMassagesPage_textInput.tr,
                          ),
                        ),
                      ),
                    ),
                    CustomSizes.largeSizedBoxHeight,
                    Divider(
                      color: COLORS.kBrightBlueColor,
                      thickness: 8,
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomSizes.largeSizedBoxHeight,
                    Padding(
                      padding: CustomSizes.contentPaddingWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            LocaleKeys.forwardMassagesPage_recentContacts.tr,
                            style: TEXTSTYLES.kLinkSmall
                                .copyWith(color: COLORS.kTextBlueColor),
                          ),
                          CustomSizes.smallSizedBoxHeight,
                          ListView.builder(
                            itemCount: controller.users.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: 8.h,
                                  top: 8.h,
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () {},
                                  child:
                                      UserWidget(User: controller.users[index]),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: COLORS.kBrightBlueColor,
                      thickness: 8,
                    ),
                    CustomSizes.largeSizedBoxHeight,
                    Padding(
                      padding: CustomSizes.contentPaddingWidth,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.forwardMassagesPage_OtherContacts.tr,
                            style: TEXTSTYLES.kLinkSmall
                                .copyWith(color: COLORS.kTextBlueColor),
                          ),
                          Obx(() {
                            return ListView.builder(
                              itemCount: controller.searchSuggestions.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                //this will grab the current user and
                                // extract the first character from its name
                                String _currentUsernamefirstchar = controller
                                    .searchSuggestions[index]
                                    .name
                                    .characters
                                    .first;
                                //this will grab the next user in the list if its not null and
                                // extract the first character from its name
                                String _nextUsernamefirstchar = controller
                                            .searchSuggestions
                                            .indexOf(controller
                                                .searchSuggestions.last) >
                                        index + 1
                                    ? controller.searchSuggestions[index + 1]
                                        .name.characters.first
                                    : "";
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 8.h,
                                    top: 8.h,
                                  ),
                                  child: Column(
                                    children: [
                                      _currentUsernamefirstchar !=
                                              _nextUsernamefirstchar
                                          ? ListHeaderWidget(
                                              title: controller
                                                  .searchSuggestions[index]
                                                  .name
                                                  .characters
                                                  .first
                                                  .toUpperCase())
                                          : const SizedBox(),
                                      InkWell(
                                        borderRadius: BorderRadius.circular(8),
                                        onTap: () {},
                                        child: UserWidget(
                                            User: controller
                                                .searchSuggestions[index]),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
