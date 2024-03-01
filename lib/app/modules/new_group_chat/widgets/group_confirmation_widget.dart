import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/new_group_chat/controllers/new_group_chat_controller.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

import '../../shared/utils/constants/textStyles.dart';
import '../../shared/utils/screen-utils/inputs/custom_text_field.dart';
import '../../shared/widgets/curtom_circle_avatar.dart';
import '../../shared/widgets/curtom_circle_button.dart';

class GroupConfirmationWidget extends StatelessWidget {
  GroupConfirmationWidget({super.key});
  final controller = Get.find<NewGroupChatController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return WillPopScope(
        onWillPop: controller.handleConfirmationWidgetPop,
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomSizes.largeSizedBoxHeight,
              _groupNameSection(),
              CustomSizes.smallSizedBoxHeight,
              const Divider(thickness: 8, color: COLORS.kBrightBlueColor),
              CustomSizes.smallSizedBoxHeight,
              _groupSettingsSection(),
              const Divider(thickness: 8, color: COLORS.kBrightBlueColor),
              _groupMembersSection(),
            ],
          ),
        ),
      );
    });
  }

  Widget _groupNameSection() {
    return Padding(
      padding: CustomSizes.mainContentPadding,
      child: Row(
        children: [
          CustomCircleButton(
            icon: Assets.svg.cameraIcon.svg(),
            onPressed: controller.handleGroupChatPhotoOnTap,
            size: 48,
          ),
          CustomSizes.mediumSizedBoxWidth,
          Expanded(
            child: FocusScope(
              child: Focus(
                onFocusChange: (focus) =>
                    controller.isconfirmationTextInputFocused.value = focus,
                focusNode: controller.confirmationScreenInputFocusNode,
                child: CustomTextField(
                  textController: controller.confirmationScreenInputController,
                  labelText: LocaleKeys.newGroupChat_GroupName.tr,
                  rightWidget: InkWell(
                    onTap: () {
                      controller.confirmationScreenInputController.clear();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Assets.svg.closeSign
                          .svg(color: COLORS.kDarkBlueColor),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _groupSettingsSection() {
    return Padding(
      padding: CustomSizes.contentPaddingWidth,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              LocaleKeys.newGroupChat_Settings_title.tr,
              style: TEXTSTYLES.kLinkSmall.copyWith(
                color: COLORS.kTextSoftBlueColor,
              ),
            ),
          ),
          CustomSizes.smallSizedBoxHeight,
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              LocaleKeys.newGroupChat_Settings_addMember.tr,
              style: TEXTSTYLES.kBodyBasic.copyWith(
                color: COLORS.kCallPageDarkBlue,
              ),
            ),
            value: controller.allowAddingMembers.value,
            onChanged: controller.handleAllowMembersOnTap,
            activeColor: COLORS.kGreenMainColor,
            inactiveTrackColor: COLORS.kBrightBlueColor,
          ),
          CustomSizes.smallSizedBoxHeight,
        ],
      ),
    );
  }

  Widget _groupMembersSection() {
    return Padding(
      padding: CustomSizes.contentPaddingWidth,
      child: Column(
        children: [
          CustomSizes.smallSizedBoxHeight,
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              LocaleKeys.newGroupChat_GroupMembers.tr,
              style: TEXTSTYLES.kLinkSmall.copyWith(
                color: COLORS.kTextSoftBlueColor,
              ),
            ),
          ),
          CustomSizes.smallSizedBoxHeight,
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.selectedCoreids.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      CustomCircleAvatar(
                        coreId: controller.selectedCoreids[index].coreId,
                        size: 48,
                        isOnline: controller.selectedCoreids[index].isOnline,
                      ),
                      CustomSizes.mediumSizedBoxWidth,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                controller.selectedCoreids[index].name,
                                style: TEXTSTYLES.kChatName
                                    .copyWith(color: COLORS.kDarkBlueColor),
                              ),
                              CustomSizes.smallSizedBoxWidth,
                              if (controller.selectedCoreids[index].isVerified)
                                Assets.svg.verifiedWithBluePadding.svg(),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            controller.selectedCoreids[index].walletAddress
                                .shortenCoreId,
                            maxLines: 1,
                            style: TEXTSTYLES.kChatText
                                .copyWith(color: COLORS.kTextBlueColor),
                          ),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
