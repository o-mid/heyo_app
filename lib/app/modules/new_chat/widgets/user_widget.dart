import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/shared/data/models/call_user_model.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/widgets/circle_icon_button.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';
import 'package:heyo/generated/assets.gen.dart';

class UserWidget extends StatelessWidget {
  final String coreId;
  final String name;
  final String walletAddress;
  final bool isOnline;
  final bool isVerified;
  final bool showAudioCallButton;
  final bool showVideoCallButton;

  const UserWidget({
    Key? key,
    required this.coreId,
    required this.name,
    required this.walletAddress,
    this.isOnline = false,
    this.isVerified = false,
    this.showAudioCallButton = false,
    this.showVideoCallButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomCircleAvatar(
          coreId: coreId,
          size: 48,
          isOnline: isOnline,
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
                  name,
                  style: TEXTSTYLES.kChatName.copyWith(color: COLORS.kDarkBlueColor),
                ),
                CustomSizes.smallSizedBoxWidth,
                if (isVerified) Assets.svg.verifiedWithBluePadding.svg(),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              walletAddress
                  .shortenCoreId, // Assuming `shortenCoreId` is available or implement accordingly
              maxLines: 1,
              style: TEXTSTYLES.kChatText.copyWith(color: COLORS.kTextBlueColor),
            ),
          ],
        ),
        const Spacer(),
        if (showAudioCallButton) ...[
          CircleIconButton(
            onPressed: _handleAudioCallButtonPressed,
            backgroundColor: COLORS.kBrightBlueColor,
            icon: Assets.svg.audioCallIcon.svg(color: COLORS.kDarkBlueColor),
          ),
          CustomSizes.mediumSizedBoxWidth,
        ],
        if (showVideoCallButton)
          CircleIconButton(
            onPressed: _handleVideoCallButtonPressed,
            backgroundColor: COLORS.kBrightBlueColor,
            icon: Assets.svg.videoCallIcon.svg(color: COLORS.kDarkBlueColor),
          ),
      ],
    );
  }

  void _handleAudioCallButtonPressed() {
    Get.toNamed(
      Routes.CALL,
      arguments: CallViewArgumentsModel(
        members: [coreId],
        callId: null,
        isAudioCall: true,
      ),
    );
  }

  void _handleVideoCallButtonPressed() {
    Get.toNamed(
      Routes.CALL,
      arguments: CallViewArgumentsModel(
        members: [coreId],
        callId: null,
        isAudioCall: false,
      ),
    );
  }
}
