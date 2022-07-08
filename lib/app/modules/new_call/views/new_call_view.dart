import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/widgets/app_bar_action_bottom_sheet.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/inputs/custom_text_field.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/contact_list_with_header.dart';
import 'package:heyo/app/modules/shared/widgets/empty_contacts_body.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

import '../controllers/new_call_controller.dart';

class NewCallView extends GetView<NewCallController> {
  const NewCallView({Key? key}) : super(key: key);
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
            onPressed: () => openAppBarActionBottomSheet(controller.profile),
            icon: Assets.svg.dotColumn.svg(
              width: 5,
            ),
          ),
        ],
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
                    child: CUSTOMTEXTFIELD(
                      textController: controller.inputController,
                      labelText: LocaleKeys.newChat_usernameInput.tr,
                      rightWidget: IconButton(
                        icon: const Icon(
                          Icons.qr_code_rounded,
                          color: COLORS.kDarkBlueColor,
                        ),
                        onPressed: controller.qrBottomSheet,
                      ),
                    ),
                  ),
                ),
              ),
              controller.searchSuggestions.isEmpty
                  ? EmptyContactsBody(
                      infoText: LocaleKeys.NewCallPage_emptyStateContactsTitle.tr,
                      buttonText: LocaleKeys.NewCallPage_invite.tr,
                      onInvite: controller.inviteBottomSheet,
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomSizes.smallSizedBoxHeight,
                        const Divider(thickness: 8, color: COLORS.kBrightBlueColor),
                        if (!controller.inputController.text.isNotEmpty) ...[
                          SizedBox(height: 24.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Text(
                              LocaleKeys.NewCallPage_contactListHeader.trParams(
                                {'count': controller.searchSuggestions.length.toString()},
                              ),
                              style: TEXTSTYLES.kLinkSmall.copyWith(
                                color: COLORS.kTextSoftBlueColor,
                              ),
                            ),
                          ),
                        ],
                        if (controller.inputController.text.isNotEmpty)
                          CustomSizes.largeSizedBoxHeight,
                        Padding(
                          padding: CustomSizes.mainContentPadding,
                          child: ContactListWithHeader(
                            contacts: controller.searchSuggestions.toList(),
                            searchMode: controller.inputController.text.isNotEmpty,
                            showAudioCallButton: true,
                            showVideoCallButton: true,
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
