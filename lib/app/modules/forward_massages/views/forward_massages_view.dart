import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/forward_massages/controllers/forward_massages_controller.dart';
import 'package:heyo/app/modules/forward_massages/widgets/contacts_widget.dart';
import 'package:heyo/app/modules/forward_massages/widgets/recent_contacts_widget.dart';
import 'package:heyo/app/modules/shared/data/models/messages_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/inputs/custom_text_field.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

import '../../shared/data/models/messaging_participant_model.dart';

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
      body: Obx(() {
        return Column(
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
                      onFocusChange: (focus) => controller.isTextInputFocused.value = focus,
                      child: CustomTextField(
                        textController: controller.inputController,
                        labelText: LocaleKeys.forwardMassagesPage_textInput.tr,
                      ),
                    ),
                  ),
                ),
                CustomSizes.largeSizedBoxHeight,
                const Divider(
                  color: COLORS.kBrightBlueColor,
                  thickness: 8,
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //dont show recent Contacts when the input is focused and its searching for users
                    controller.isTextInputFocused.value
                        ? const SizedBox()
                        : RecentContactsWidget(
                            users: controller.users,
                            userSelect: controller.setSelectedUser,
                          ),
                    ContactsWidget(
                      isTextInputFocused: controller.isTextInputFocused,
                      searchSuggestions: controller.searchSuggestions,
                      userSelect: controller.setSelectedUser,
                    ),
                    CustomSizes.largeSizedBoxHeight,
                  ],
                ),
              ),
            ),
            controller.selectedUserName.isNotEmpty
                ? Container(
                    decoration: const BoxDecoration(
                      color: COLORS.kComposeMessageBackgroundColor,
                      border: Border(
                        top: BorderSide(
                          width: 1,
                          color: COLORS.kComposeMessageBorderColor,
                        ),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 20.w,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Assets.svg.forwardTo.svg(
                              width: 19.w,
                              height: 17.w,
                              color: COLORS.kDarkBlueColor,
                            ),
                            CustomSizes.mediumSizedBoxWidth,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    LocaleKeys.forwardMassagesPage_bottomBar_forwardTO.tr +
                                        controller.selectedUserName.value,
                                    style: TEXTSTYLES.kChatText.copyWith(
                                      color: COLORS.kDarkBlueColor,
                                      fontWeight: FONTS.SemiBold,
                                    ),
                                  ),
                                  Text(
                                    controller.selectedMessages.length.toString() +
                                        LocaleKeys.forwardMassagesPage_bottomBar_messages.tr,
                                    style: TEXTSTYLES.kChatText.copyWith(
                                      color: COLORS.kTextBlueColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (controller.selectedUser != null) {
                                  Get.offNamedUntil(
                                    Routes.MESSAGES,
                                    ModalRoute.withName(Routes.HOME),
                                    arguments: MessagesViewArgumentsModel(
                                        forwardedMessages: controller.selectedMessages,
                                        participants: [
                                          MessagingParticipantModel(
                                            coreId: controller.selectedUser!.coreId,
                                          )
                                        ]),
                                  );
                                }
                              },
                              child: Assets.svg.sendIcon.svg(
                                width: 19.w,
                                height: 17.w,
                              ),
                            )
                          ],
                        ),
                        CustomSizes.largeSizedBoxHeight,
                      ],
                    ),
                  )
                : const SizedBox(),
          ],
        );
      }),
    );
  }
}
