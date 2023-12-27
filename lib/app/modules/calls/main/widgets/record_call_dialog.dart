//import 'package:flutter/material.dart';
//import 'package:get/get.dart';
//import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
//import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
//import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
//import 'package:heyo/app/modules/shared/widgets/custom_button.dart';
//import 'package:heyo/app/modules/shared/widgets/modified_alert_dialog.dart';
//import 'package:heyo/generated/assets.gen.dart';
//import 'package:heyo/generated/locales.g.dart';

//class RecordCallDialog extends StatelessWidget {
//  final Function onRecord;

//  const RecordCallDialog({super.key, required this.onRecord});

//  @override
//  Widget build(BuildContext context) {
//    return ModifiedAlertDialog(
//      alertContent: DefaultAlertDialogContent(
//        indicatorIcon: Assets.svg.recordWordWithDot.svg(
//          color: COLORS.kStatesErrorColor,
//        ),
//        indicatorBackgroundColor: COLORS.kStatesLightErrorColor,
//        title: LocaleKeys.recordCallDialog_title.tr,
//        subtitle: LocaleKeys.recordCallDialog_subtitle.tr,
//        buttons: [
//          CustomButton(
//            onTap: () {
//              onRecord();
//              Get.back();
//            },
//            title: LocaleKeys.recordCallDialog_acceptButton.tr,
//            textStyle: TEXTSTYLES.kLinkBig.copyWith(
//              color: COLORS.kStatesErrorColor,
//            ),
//            backgroundColor: COLORS.kStatesLightErrorColor,
//          ),
//          CustomSizes.smallSizedBoxHeight,
//          CustomButton(
//            onTap: Get.back,
//            title: LocaleKeys.recordCallDialog_cancelButton.tr,
//            textStyle: TEXTSTYLES.kLinkBig.copyWith(
//              color: COLORS.kTextBlueColor,
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//}
