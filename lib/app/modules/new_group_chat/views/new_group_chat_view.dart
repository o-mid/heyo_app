import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/empty_users_body.dart';
import 'package:heyo/app/modules/shared/widgets/contact_list_with_header.dart';
import 'package:heyo/app/modules/new_chat/widgets/new_chat_qr_scanner.dart';
import 'package:heyo/app/modules/add_participate/widgets/invite_bttom_sheet.dart';
import 'package:heyo/app/modules/new_group_chat/widgets/contact_list.dart';
import 'package:heyo/app/modules/new_group_chat/controllers/new_group_chat_controller.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

import '../../shared/utils/screen-utils/inputs/custom_text_field.dart';

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
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomSizes.largeSizedBoxHeight,
          _buildSearchInput(),
          if (controller.searchSuggestions.isEmpty) _buildEmptyUsersBody() else _buildContactList(),
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
