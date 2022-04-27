import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/inputs/custom_text_field.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';

import '../../../../generated/locales.g.dart';
import '../../new_chat/widgets/user_widget.dart';
import '../controllers/forward_massages_controller.dart';

class ForwardMassagesView extends GetView<ForwardMassagesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
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
                  labelText: LocaleKeys.forwardMassagesPage_textInput.tr,
                ),
              ),
            ),
          ),
          CustomSizes.largeSizedBoxHeight,
          Divider(
            color: COLORS.kBrightBlueColor,
            thickness: 8,
          ),
          CustomSizes.largeSizedBoxHeight,
          Padding(
            padding: CustomSizes.contentPaddingWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        child: UserWidget(User: controller.users[index]),
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
        ],
      ),
    );
  }
}
