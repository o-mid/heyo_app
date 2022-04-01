import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/buttons/custom_button.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import '../../../shared/utils/constants/textStyles.dart';
import '../controllers/sing_up_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SingUpView extends GetView<SingUpController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLORS.kWhiteColor,
      appBar: _appbar(),
      body: Container(
        padding: CustomSizes.mainContentPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: _pages.length,
                controller: controller.pagecontroller,
                itemBuilder: (context, index) {
                  return _pages[index];
                },
              ),
            ),
            SmoothPageIndicator(
              count: _pages.length,
              controller: controller.pagecontroller,
              onDotClicked: (index) => controller.pagecontroller.animateToPage(
                  index,
                  duration: Duration(milliseconds: 350),
                  curve: Curves.ease),
              effect: WormEffect(
                  dotHeight: 8.w,
                  dotWidth: 8.w,
                  type: WormType.normal,
                  dotColor: COLORS.kDeactivateDotColor,
                  activeDotColor: COLORS.kGreenMainColor),
            ),
            CustomSizes.mediumSizedBoxHeight,
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomButton.primary(
                  // TODO: implement Create CoreID
                  onTap: () {},
                  title: LocaleKeys.registration_BenefitsPage_buttons_Create.tr,
                ),
                CustomSizes.mediumSizedBoxHeight,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Divider(
                        color: COLORS.kTextSoftBlueColor,
                      ),
                    ),
                    CustomSizes.smallSizedBoxWidth,
                    Text(
                      LocaleKeys.registration_BenefitsPage_divider.tr,
                      textAlign: TextAlign.center,
                      style: TEXTSTYLES.kBodyTag
                          .copyWith(color: COLORS.kTextSoftBlueColor),
                    ),
                    CustomSizes.smallSizedBoxWidth,
                    Expanded(
                      child: Divider(
                        color: COLORS.kTextSoftBlueColor,
                      ),
                    ),
                  ],
                ),
                CustomSizes.mediumSizedBoxHeight,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton.outline(
                        // TODO : Implement Recover account
                        onTap: () {},
                        title: LocaleKeys
                            .registration_BenefitsPage_buttons_Recover.tr),
                    CustomButton.outline(
                        // TODO : Implement Migrate account
                        onTap: () {},
                        title: LocaleKeys
                            .registration_BenefitsPage_buttons_Migrate.tr),
                  ],
                ),
                CustomSizes.mediumSizedBoxHeight,
                _footer()
              ],
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appbar() {
    return AppBar(
        elevation: 0,
        backgroundColor: COLORS.kWhiteColor,
        automaticallyImplyLeading: false,
        actions: [
          CustomButton(
            //TODO : What is corepass
            onTap: () {},
            titleWidget: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  LocaleKeys.registration_BenefitsPage_buttons_Whatis.tr,
                  style: TEXTSTYLES.kButtonBasic
                      .copyWith(color: COLORS.kGreenMainColor),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 15.w,
                  color: COLORS.kGreenMainColor,
                ),
              ],
            ),
            size: CustomButtonSize.small,
          ),
        ]);
  }

  Widget _footer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(LocaleKeys.registration_BenefitsPage_footer.tr,
            style: TEXTSTYLES.kBodyTag.copyWith(color: COLORS.kTextBlueColor)),
        SizedBox(width: 5.w),
        Assets.svg.corePassLogo.svg(height: 15.h),
      ],
    );
  }

  final List<Widget> _pages = [
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Assets.png.benefits.image(
          alignment: Alignment.center,
        ),
        Text(
          LocaleKeys.registration_BenefitsPage_title.tr,
          style: TEXTSTYLES.kHeaderDisplay,
          textAlign: TextAlign.center,
        ),
        CustomSizes.mediumSizedBoxHeight,
        Text(
          LocaleKeys.registration_BenefitsPage_subtitle.tr,
          style: TEXTSTYLES.kBodyBasic,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  ];
}
