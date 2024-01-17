import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/new_call/controllers/new_call_controller.dart';
import 'package:heyo/app/modules/calls/new_call/widgets/contact_list_widget.dart';
import 'package:heyo/app/modules/new_chat/widgets/app_bar_action_bottom_sheet.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/inputs/custom_text_field.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/empty_users_body.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class NewCallView extends GetView<NewCallController> {
  const NewCallView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: COLORS.kGreenMainColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          LocaleKeys.NewCallPage_appBarTitle.tr,
          style: TEXTSTYLES.kHeaderLarge.copyWith(color: COLORS.kWhiteColor),
        ),
        actions: [
          IconButton(
            onPressed: () => openAppBarActionBottomSheet(
              profileLink: controller.profileLink,
            ),
            icon: Assets.svg.dotColumn.svg(
              width: 5,
            ),
          ),
        ],
      ),
      body: Obx(() {
        //* If list is empty show the empty screen
        final emptyScreen = controller.searchItems.isEmpty;

        return Column(
          children: [
            CustomSizes.largeSizedBoxHeight,
            Padding(
              padding: CustomSizes.mainContentPadding,
              child: FocusScope(
                child: Focus(
                  onFocusChange: (focus) =>
                      controller.isTextInputFocused.value = focus,
                  child: CustomTextField(
                    onChanged: controller.searchUsers,
                    labelText: LocaleKeys.newChat_usernameInput.tr,
                    rightWidget: IconButton(
                      icon: const Icon(
                        Icons.qr_code_rounded,
                        color: COLORS.kDarkBlueColor,
                        size: 24,
                      ),
                      onPressed: controller.qrBottomSheet,
                    ),
                  ),
                ),
              ),
            ),
            if (emptyScreen)
              Expanded(
                child: ListView(
                  children: [
                    EmptyUsersBody(
                      infoText: LocaleKeys.newChat_emptyStateTitleContacts.tr,
                      buttonText: LocaleKeys.newChat_buttons_invite.tr,
                      onInvite: controller.inviteBottomSheet,
                    ),
                  ],
                ),
              )
            else
              const ContactListWidget(),
          ],
        );
      }),
    );
  }
}
