import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/locales.g.dart';

class VerificationLoading extends StatelessWidget {
  const VerificationLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            COLORS.kGreenMainColor,
          ),
        ),
        CustomSizes.mediumSizedBoxHeight,
        Text(
          LocaleKeys.registration_WelcomePage_dialogTitle.tr,
          style: TEXTSTYLES.kHeaderMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
