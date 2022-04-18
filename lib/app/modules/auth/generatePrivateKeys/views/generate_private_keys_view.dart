import 'package:flutter/material.dart';
import '../../../shared/utils/screen-utils/sizing/custom_sizes.dart';
import '../controllers/generate_private_keys_controller.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class GeneratePrivateKeysView extends GetView<GeneratePrivateKeysController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLORS.kWhiteColor,
      body: Container(
        padding: CustomSizes.mainContentPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.png.keys.image(alignment: Alignment.center),
            CustomSizes.extraLargeSizedBoxHeight,
            FittedBox(
              child: Text(
                LocaleKeys.registration_PrivateKeysPage_Generating.tr,
                style: TEXTSTYLES.kHeaderDisplay,
              ),
            ),
            CustomSizes.largeSizedBoxHeight,
            LinearProgressIndicator(
              color: COLORS.kGreenMainColor,
              backgroundColor: COLORS.kBrightBlueColor,
            ),
            CustomSizes.largeSizedBoxHeight,
          ],
        ),
      ),
    );
  }
}
