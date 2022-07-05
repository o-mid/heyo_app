import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/widgets/circle_icon_button.dart';
import 'package:heyo/app/routes/app_pages.dart';
import '../data/models/user_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';
import 'package:heyo/generated/assets.gen.dart';

class UserWidget extends StatelessWidget {
  final UserModel user;
  final bool showCallButton;
  const UserWidget({
    Key? key,
    required this.user,
    this.showCallButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomCircleAvatar(
          url: user.icon,
          size: 48,
          isOnline: user.isOnline,
        ),
        CustomSizes.mediumSizedBoxWidth,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(user.name, style: TEXTSTYLES.kChatName.copyWith(color: COLORS.kDarkBlueColor)),
                CustomSizes.smallSizedBoxWidth,
                if (user.isVerified) Assets.svg.verifiedWithBluePadding.svg(),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              user.walletAddress.shortenCoreId,
              maxLines: 1,
              style: TEXTSTYLES.kChatText.copyWith(color: COLORS.kTextBlueColor),
            ),
          ],
        ),
        const Spacer(),
        if (showCallButton)
          CircleIconButton(
            onPressed: () {
              Get.toNamed(
                Routes.CALL,
                arguments: CallViewArgumentsModel(
                  user: user,
                  initiateCall: true,
                  callId: null,
                ),
              );
            },
            backgroundColor: COLORS.kBrightBlueColor,
            icon: Assets.svg.audioCallIcon.svg(color: COLORS.kDarkBlueColor),
          ),
      ],
    );
  }
}
