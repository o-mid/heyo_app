import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/add_participate/controllers/add_participate_controller.dart';
import 'package:heyo/app/modules/add_participate/controllers/participate_item_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/widgets/circle_icon_button.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';
import 'package:heyo/generated/assets.gen.dart';

class AddableUserWidget extends StatelessWidget {
  final ParticipateItem user;

  const AddableUserWidget({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddParticipateController>();

    return InkWell(
      onTap: () => controller.addUser(user),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomCircleAvatar(
            url: user.iconUrl,
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
                  Text(
                    user.name,
                    style: TEXTSTYLES.kChatName.copyWith(
                      color: COLORS.kDarkBlueColor,
                    ),
                  ),
                  CustomSizes.smallSizedBoxWidth,
                  if (user.isVerified) Assets.svg.verifiedWithBluePadding.svg(),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                user.walletAddress.shortenCoreId,
                maxLines: 1,
                style: TEXTSTYLES.kChatText.copyWith(
                  color: COLORS.kTextBlueColor,
                ),
              ),
            ],
          ),
          const Spacer(),

          // Below code is + icon for adding multiple participate in call
          CircleIconButton(
            backgroundColor: COLORS.kBrightBlueColor,
            icon: Assets.svg.addCircle.svg(color: COLORS.kDarkBlueColor),
          ),
        ],
      ),
    );
  }
}
