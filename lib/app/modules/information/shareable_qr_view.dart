import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/information/shareable_qr_controller.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/circle_icon_button.dart';
import 'package:heyo/app/modules/shared/widgets/custom_button.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ShareableQrView extends GetView<ShareableQRController> {
  const ShareableQrView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLORS.kAppBackground,
      appBar: AppBar(
        title: Text(
          LocaleKeys.ShareableQrPage_appBarTitle.tr,
          style: TEXTSTYLES.kHeaderLarge.copyWith(color: COLORS.kWhiteColor),
        ),
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(
            Icons.arrow_back,
            color: COLORS.kWhiteColor,
          ),
        ),
        centerTitle: false,
        backgroundColor: COLORS.kGreenMainColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 44.w),
              child: Text(
                LocaleKeys.ShareableQrPage_scanQrTitle.tr,
                style: TEXTSTYLES.kBodyBasic.copyWith(color: COLORS.kTextSoftBlueColor),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 24.h),
            Obx(() {
              return QrImage(
                padding: const EdgeInsets.all(0),
                data: controller.shareableQr.value,
                version: QrVersions.auto,
                size: 241.0,
              );
            }),
            SizedBox(height: 32.h),
            CustomButton(
              takeFullWidth: false,
              padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 32.w),
              backgroundColor: COLORS.kGreenLighterColor,
              textStyle: TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kGreenMainColor),
              onTap: () {},
              title: LocaleKeys.ShareableQrPage_shareQrButtonTitle.tr,
            ),
            SizedBox(height: 40.h),
            _buildTextDivider(),
            SizedBox(height: 40.h),
            Text(
              LocaleKeys.ShareableQrPage_shareCoreIdTitle.tr,
              style: TEXTSTYLES.kBodyBasic.copyWith(color: COLORS.kTextSoftBlueColor),
            ),
            SizedBox(height: 16.h),
            _buildCoreIdContainer(),
            SizedBox(height: 32.h),
            CustomButton(
              takeFullWidth: false,
              padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 32.w),
              backgroundColor: COLORS.kGreenLighterColor,
              textStyle: TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kGreenMainColor),
              onTap: () {
                Share.share(controller.coreId.value ?? '');
              },
              title: LocaleKeys.ShareableQrPage_shareCoreIdButtonTitle.tr,
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTextDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
            child: Divider(
              color: COLORS.kDividerColor,
              thickness: 2,
            ),
          ),
          CustomSizes.smallSizedBoxWidth,
          Text(
            LocaleKeys.ShareableQrPage_textDividerTitle.tr,
            style: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kTextSoftBlueColor),
          ),
          CustomSizes.smallSizedBoxWidth,
          const Expanded(
            child: Divider(
              color: COLORS.kDividerColor,
              thickness: 2,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCoreIdContainer() {
    return Obx(() {
      final coreId = controller.coreId.value;
      final textStyle = TEXTSTYLES.kLinkBig.copyWith(
        color: COLORS.kTextSoftBlueColor,
      );
      const trailingStringLength = 4;
      return Container(
        padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 16.w),
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: COLORS.kBrightBlueColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: coreId == null || coreId.length < trailingStringLength
            ? const Text('')
            : Row(
                children: [
                  Expanded(
                    child: Text(
                      coreId.substring(0, coreId.length - trailingStringLength),
                      style: textStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    coreId.substring(coreId.length - trailingStringLength),
                    style: textStyle,
                  ),
                  SizedBox(width: 22.w),
                  CircleIconButton(
                    size: 24.w,
                    onPressed: () async {
                      print("Core ID : $coreId");
                      await Clipboard.setData(ClipboardData(text: coreId));
                      Get.rawSnackbar(
                        messageText: Text(
                          LocaleKeys.ShareableQrPage_copiedToClipboardText.tr,
                          style: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kDarkBlueColor),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
                        backgroundColor: COLORS.kWhiteColor,
                        snackStyle: SnackStyle.FLOATING,
                        maxWidth: 250.w,
                        margin: EdgeInsets.only(bottom: 60.h),
                        boxShadows: [
                          BoxShadow(
                            color: const Color(0xFF466087).withOpacity(0.1),
                            offset: const Offset(0, 3),
                            blurRadius: 10,
                          ),
                        ],
                        borderRadius: 8,
                      );
                    },
                    backgroundColor: Colors.transparent,
                    icon: Assets.svg.copyIcon.svg(
                      color: COLORS.kDarkBlueColor,
                    ),
                  ),
                ],
              ),
      );
    });
  }
}
