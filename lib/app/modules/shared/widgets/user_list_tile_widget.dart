import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/controllers/user_preview_controller.dart';

import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/circle_icon_button.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/assets.gen.dart';

class UserListTileWidget extends StatelessWidget {
  const UserListTileWidget({
    required this.name,
    required this.coreId,
    super.key,
    this.showAudioCallButton = false,
    this.showVideoCallButton = false,
  });
  //final UserModel user;
  final String coreId;
  final String name;
  final bool showAudioCallButton;
  final bool showVideoCallButton;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //* Close keyboard before opening bottom sheet
        FocusScope.of(context).unfocus();
        Get.find<UserPreviewController>().openUserPreview(coreId: coreId);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Row(
          children: [
            CustomCircleAvatar(
              coreId: coreId,
              size: 48,
            ),
            CustomSizes.mediumSizedBoxWidth,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: TEXTSTYLES.kChatName
                          .copyWith(color: COLORS.kDarkBlueColor),
                    ),
                    CustomSizes.smallSizedBoxWidth,
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  coreId.shortenCoreId,
                  maxLines: 1,
                  style: TEXTSTYLES.kChatText
                      .copyWith(color: COLORS.kTextBlueColor),
                ),
              ],
            ),
            const Spacer(),
            if (showAudioCallButton)
              CircleIconButton(
                onPressed: () {
                  Get.toNamed(
                    Routes.CALL,
                    arguments: CallViewArgumentsModel(
                      members: [coreId],
                      callId: null,
                      isAudioCall: true,
                    ),
                  );
                },
                backgroundColor: COLORS.kBrightBlueColor,
                icon: Assets.svg.audioCallIcon.svg(
                  color: COLORS.kDarkBlueColor,
                ),
              ),
            CustomSizes.mediumSizedBoxWidth,
            if (showVideoCallButton)
              CircleIconButton(
                onPressed: () {
                  Get.toNamed(
                    Routes.CALL,
                    arguments: CallViewArgumentsModel(
                      members: [coreId],
                      callId: null,
                      isAudioCall: false,
                    ),
                  );
                },
                backgroundColor: COLORS.kBrightBlueColor,
                icon: Assets.svg.videoCallIcon.svg(
                  color: COLORS.kDarkBlueColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
