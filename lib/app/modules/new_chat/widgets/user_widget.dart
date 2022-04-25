import 'package:flutter/material.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import '../data/models/user_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/utils/widgets/curtom_circle_avatar.dart';
import 'package:heyo/generated/assets.gen.dart';

class UserWidget extends StatelessWidget {
  final UserModel User;
  const UserWidget({Key? key, required this.User}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomCircleAvatar(
          url: User.icon,
          size: 48,
          isOnline: User.isOnline,
        ),
        CustomSizes.mediumSizedBoxWidth,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(User.name,
                    style: TEXTSTYLES.kChatName
                        .copyWith(color: COLORS.kDarkBlueColor)),
                CustomSizes.smallSizedBoxWidth,
                if (User.isVerified) Assets.svg.verifiedWithBluePadding.svg(),
              ]),
              const SizedBox(
                height: 4,
              ),
              Text(
                User.walletAddress,
                maxLines: 1,
                style:
                    TEXTSTYLES.kChatText.copyWith(color: COLORS.kTextBlueColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
