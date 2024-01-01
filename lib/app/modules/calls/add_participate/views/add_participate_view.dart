import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/add_participate/controllers/add_participate_controller.dart';
import 'package:heyo/app/modules/calls/add_participate/widgets/appbar_add_participate.dart';
import 'package:heyo/app/modules/calls/add_participate/widgets/invite_bttom_sheet.dart';
import 'package:heyo/app/modules/calls/add_participate/widgets/participant_list_widget.dart';
import 'package:heyo/app/modules/calls/add_participate/widgets/textfield_add_participate.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/custom_button.dart';
import 'package:heyo/app/modules/shared/widgets/empty_users_body.dart';
import 'package:heyo/generated/locales.g.dart';

class AddParticipateView extends GetView<AddParticipateController> {
  const AddParticipateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarAddParticipate(controller),
      body: Obx(() {
        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    CustomSizes.largeSizedBoxHeight,
                    const TextfieldAddParticipate(),
                    if (controller.searchItems.isEmpty &&
                        controller.inputText.value.isEmpty)
                      EmptyUsersBody(
                        infoText: LocaleKeys.newChat_emptyStateTitleContacts.tr,
                        buttonText: LocaleKeys.newChat_buttons_invite.tr,
                        onInvite: () => openInviteBottomSheet(
                          profileLink: controller.profileLink,
                        ),
                      )
                    else
                      const ParticipantListWidget(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: CustomButton(
                  title: 'Add to Call (${controller.selectedUser.length})',
                  textStyle: TEXTSTYLES.kLinkBig.copyWith(
                    color: COLORS.kWhiteColor,
                  ),
                  backgroundColor: controller.selectedUser.isEmpty
                      ? COLORS.kShimmerBase
                      : COLORS.kGreenMainColor,
                  onTap: controller.addUsersToCall,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
