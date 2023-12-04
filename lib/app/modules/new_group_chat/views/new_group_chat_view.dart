import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/inputs/custom_text_field.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/empty_users_body.dart';
import 'package:heyo/generated/assets.gen.dart';

import '../../../../generated/locales.g.dart';
import '../../add_participate/widgets/invite_bttom_sheet.dart';
import '../../new_chat/widgets/new_chat_qr_scanner.dart';
import '../../shared/utils/constants/colors.dart';
import '../../shared/utils/constants/fonts.dart';
import '../../shared/widgets/contact_list_with_header.dart';
import '../controllers/new_group_chat_controller.dart';
import '../widgets/contact_list.dart';

class NewGroupChatView extends GetView<NewGroupChatController> {
  const NewGroupChatView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: COLORS.kGreenMainColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          LocaleKeys.newGroupChat_GroupChatAppBar.tr,
          style: const TextStyle(
            fontWeight: FONTS.Bold,
            fontFamily: FONTS.interFamily,
          ),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Obx(() {
        return SingleChildScrollView(
          child: Column(
            children: [
              CustomSizes.largeSizedBoxHeight,
              Padding(
                padding: CustomSizes.mainContentPadding,
                child: FocusScope(
                  child: Focus(
                    onFocusChange: (focus) => controller.isTextInputFocused.value = focus,
                    focusNode: controller.inputFocusNode,
                    child: CustomTextField(
                      textController: controller.inputController,
                      labelText: LocaleKeys.newChat_usernameInput.tr,
                      rightWidget: IconButton(
                        icon: Assets.svg.qrCode.svg(
                          width: 20.w,
                          fit: BoxFit.fitWidth,
                        ),
                        onPressed: () => {openQrScannerBottomSheet(controller.handleScannedValue)},
                      ),
                    ),
                  ),
                ),
              ),
              if (controller.searchSuggestions.isEmpty)
                EmptyUsersBody(
                  infoText: LocaleKeys.newChat_emptyStateTitleContacts.tr,
                  buttonText: LocaleKeys.newChat_buttons_invite.tr,
                  onInvite: () => openInviteBottomSheet(
                    profileLink: controller.profileLink,
                  ),
                )
              else
                Column(
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
                ),
            ],
          ),
        );
      }),
    );
  }
}
