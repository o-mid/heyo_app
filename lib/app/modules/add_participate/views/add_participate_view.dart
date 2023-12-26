import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/add_participate/controllers/add_participate_controller.dart';
import 'package:heyo/app/modules/add_participate/widgets/appbar_add_participate.dart';
import 'package:heyo/app/modules/add_participate/widgets/invite_bttom_sheet.dart';
import 'package:heyo/app/modules/add_participate/widgets/search_in_contact_add_participate.dart';
import 'package:heyo/app/modules/add_participate/widgets/textfield_add_participate.dart';
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
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ListView(
                children: [
                  CustomSizes.largeSizedBoxHeight,
                  const TextfieldAddParticipate(),
                  if (controller.searchItems.isEmpty)
                    EmptyUsersBody(
                      infoText: LocaleKeys.newChat_emptyStateTitleContacts.tr,
                      buttonText: LocaleKeys.newChat_buttons_invite.tr,
                      onInvite: () => openInviteBottomSheet(
                        profileLink: controller.profileLink,
                      ),
                    )
                  else
                    SearchInContactsBody(controller),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(24),
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
