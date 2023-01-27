import 'package:flutter/material.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/assets.gen.dart';

import '../utils/screen-utils/buttons/custom_button.dart';

class EmptyUsersBody extends StatelessWidget {
  const EmptyUsersBody({
    Key? key,
    this.onInvite,
    required this.infoText,
    this.buttonText,
  }) : super(key: key);

  final VoidCallback? onInvite;
  final String infoText;
  final String? buttonText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomSizes.largeSizedBoxHeight,
        Center(
          child: Assets.png.newChatEmptyState.image(
            alignment: Alignment.center,
          ),
        ),
        CustomSizes.largeSizedBoxHeight,
        Text(
          infoText,
          style: TEXTSTYLES.kBodyBasic.copyWith(
            color: COLORS.kTextBlueColor,
          ),
          textAlign: TextAlign.center,
        ),
        CustomSizes.largeSizedBoxHeight,
        buttonText == null
            ? const SizedBox()
            : CustomButton.primarySmall(
                onTap: onInvite,
                color: COLORS.kGreenLighterColor,
                title: buttonText,
                style: TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kGreenMainColor)),
      ],
    );
  }
}
