import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/empty_users_body.dart';
import 'package:heyo/app/modules/shared/widgets/contact_list_with_header.dart';
import 'package:heyo/app/modules/new_chat/widgets/new_chat_qr_scanner.dart';
import 'package:heyo/app/modules/add_participate/widgets/invite_bttom_sheet.dart';
import 'package:heyo/app/modules/new_group_chat/widgets/contact_list.dart';
import 'package:heyo/app/modules/new_group_chat/controllers/new_group_chat_controller.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

import '../../shared/utils/constants/textStyles.dart';
import '../../shared/utils/screen-utils/inputs/custom_text_field.dart';
import '../../shared/widgets/curtom_circle_avatar.dart';
import '../../shared/widgets/curtom_circle_button.dart';

class NewGroupChatView extends GetView<NewGroupChatController> {
  const NewGroupChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: _buildAppBar(),
        floatingActionButton: _buildFAB(),
        body: _buildbody(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: COLORS.kGreenMainColor,
      elevation: 0,
      centerTitle: false,
      title: Text(
        controller.selectedCoreids.isEmpty
            ? LocaleKeys.newGroupChat_GroupChatAppBar.tr
            : '${controller.selectedCoreids.length} ${LocaleKeys.newGroupChat_Selected.tr}',
        style: const TextStyle(
          fontWeight: FONTS.Bold,
          fontFamily: FONTS.interFamily,
        ),
      ),
      automaticallyImplyLeading: true,
    );
  }

  Widget _buildFAB() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: FloatingActionButton(
        onPressed: controller.handleFabOnpressed,
        backgroundColor:
            controller.selectedCoreids.length <= 1 ? Colors.grey : COLORS.kGreenMainColor,
        child: Assets.svg.arrowIcon.svg(width: 20.w, color: COLORS.kWhiteColor),
      ),
    );
  }

  Widget _buildbody() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: controller.showConfirmationScreen.value
          ? _groupConfirmationWidget()
          : SingleChildScrollView(
              child: Column(
                children: [
                  CustomSizes.largeSizedBoxHeight,
                  _buildSearchInput(),
                  if (controller.searchSuggestions.isEmpty)
                    _buildEmptyUsersBody()
                  else
                    _buildContactList(),
                ],
              ),
            ),
    );
  }

  Widget _groupConfirmationWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomSizes.largeSizedBoxHeight,
          Padding(
            padding: CustomSizes.mainContentPadding,
            child: Row(
              children: [
                CustomCircleButton(
                  icon: Assets.svg.cameraIcon.svg(),
                  onPressed: null,
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
                            child: Assets.svg.closeSign.svg(color: COLORS.kDarkBlueColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomSizes.smallSizedBoxHeight,
          const Divider(thickness: 8, color: COLORS.kBrightBlueColor),
          CustomSizes.smallSizedBoxHeight,
          Padding(
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
                ),
                CustomSizes.smallSizedBoxHeight,
              ],
            ),
          ),
          const Divider(thickness: 8, color: COLORS.kBrightBlueColor),
          Padding(
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomCircleAvatar(
                              url: controller.selectedCoreids[index].iconUrl,
                              size: 48,
                              isOnline: controller.selectedCoreids[index].isOnline,
                            ),
                            CustomSizes.mediumSizedBoxWidth,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                  controller.selectedCoreids[index].walletAddress.shortenCoreId,
                                  maxLines: 1,
                                  style:
                                      TEXTSTYLES.kChatText.copyWith(color: COLORS.kTextBlueColor),
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
          ),
        ],
      ),
    );
  }

  Widget _buildSearchInput() {
    return Padding(
      padding: CustomSizes.mainContentPadding,
      child: FocusScope(
        child: Focus(
          onFocusChange: (focus) => controller.isTextInputFocused.value = focus,
          focusNode: controller.inputFocusNode,
          child: CustomTextField(
            textController: controller.inputController,
            labelText: LocaleKeys.newChat_usernameInput.tr,
            rightWidget: IconButton(
              icon: Assets.svg.qrCode.svg(width: 20.w, fit: BoxFit.fitWidth),
              onPressed: () => openQrScannerBottomSheet(controller.handleScannedValue),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyUsersBody() {
    return EmptyUsersBody(
      infoText: LocaleKeys.newChat_emptyStateTitleContacts.tr,
      buttonText: LocaleKeys.newChat_buttons_invite.tr,
      onInvite: () => openInviteBottomSheet(profileLink: controller.profileLink),
    );
  }

  Widget _buildContactList() {
    return Column(
      children: [
        CustomSizes.smallSizedBoxHeight,
        const Divider(thickness: 8, color: COLORS.kBrightBlueColor),
        CustomSizes.largeSizedBoxHeight,
        Padding(
          padding: CustomSizes.mainContentPadding,
          child: ContactList(
            contacts: controller.searchSuggestions,
            searchMode: controller.inputController.text.isNotEmpty,
          ),
        ),
      ],
    );
  }
}
