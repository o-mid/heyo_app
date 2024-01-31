import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/add_contacts/controllers/add_contacts_controller.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/buttons/custom_button.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/inputs/custom_text_field.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class AddContactsView extends GetView<AddContactsController> {
  const AddContactsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: COLORS.kGreenMainColor,
            elevation: 0,
            centerTitle: false,
            title: Text(
              controller.isContact.value
                  ? LocaleKeys.AddContacts_Edit_Contact.tr
                  : LocaleKeys.AddContacts_addToContacts.tr,
              style: const TextStyle(
                fontWeight: FONTS.Bold,
                fontFamily: FONTS.interFamily,
              ),
            ),
          ),
          body: Padding(
            padding: CustomSizes.mainContentPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    CustomSizes.largeSizedBoxHeight,
                    CustomCircleAvatar(
                      coreId: controller.args.coreId,
                      size: 64,
                    ),
                    CustomSizes.mediumSizedBoxHeight,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.nickname.value.isEmpty
                              ? controller.args.coreId.shortenCoreId
                              : controller.nickname.value,
                          style: TEXTSTYLES.kHeaderLarge
                              .copyWith(color: COLORS.kDarkBlueColor),
                        ),
                        CustomSizes.smallSizedBoxWidth,
                        if (controller.isVerified.value)
                          Assets.svg.verifiedWithBluePadding.svg(
                            height: 24.w,
                            width: 24.w,
                          )
                        else
                          const SizedBox(),
                      ],
                    ),
                    CustomSizes.smallSizedBoxHeight,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.args.coreId.shortenCoreId,
                          style: TEXTSTYLES.kBodySmall.copyWith(
                            color: COLORS.kTextBlueColor,
                          ),
                        ),
                        Row(
                          children: [
                            CustomSizes.smallSizedBoxWidth,
                            Assets.svg.dotIndicator.svg(),
                            CustomSizes.smallSizedBoxWidth,
                          ],
                        )
                      ],
                    ),
                    CustomSizes.smallSizedBoxHeight,
                    SizedBox(
                      height: 40.h,
                    ),
                    CustomTextField(
                      labelText: LocaleKeys.AddContacts_addNickname.tr,
                      onChanged: (String value) =>
                          controller.setNickname(value),
                      textController: controller.myNicknameController,
                    ),
                    CustomSizes.mediumSizedBoxHeight,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        LocaleKeys.AddContacts_AddNicknameSubtitle.tr,
                        style: TEXTSTYLES.kBodySmall,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    CustomButton.primary(
                      // TODO : chatModel should be filled with correct data
                      onTap: () async {
                        await controller.updateContact();
                      },

                      titleWidget: Text(
                        controller.isContact.value
                            ? LocaleKeys.AddContacts_Update_Contact.tr
                            : LocaleKeys.AddContacts_buttons_addToContacts.tr,
                        style: TEXTSTYLES.kLinkBig.copyWith(
                          color: COLORS.kWhiteColor,
                        ),
                      ),
                    ),
                    CustomSizes.largeSizedBoxHeight,
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
