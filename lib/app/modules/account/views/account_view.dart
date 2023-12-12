import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/appbar_widget.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';
import 'package:heyo/app/modules/shared/widgets/menu_item_widget.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

import '../controllers/account_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLORS.kAppBackground,
      appBar: AppBarWidget(title: LocaleKeys.AccountPage_appBarTitle.tr),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 23.h),
            Row(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.SHREABLE_QR);
                  },
                  child: Assets.svg.qrCode.svg(
                    width: 20.w,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                SizedBox(width: 23.w),
              ],
            ),
            CustomCircleAvatar(
              coreId: controller.coreId.value,
              size: 64,
            ),
            CustomSizes.mediumSizedBoxHeight,
            Text(
              "Scrambled Gurgle",
              style: TEXTSTYLES.kHeaderLarge.copyWith(color: COLORS.kDarkBlueColor),
            ),
            SizedBox(height: 4.h),
            Text(
              controller.coreId.value.shortenCoreId,
              style: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kTextSoftBlueColor),
            ),
            SizedBox(height: 60.h),
            const Divider(
              color: COLORS.kChatStroke,
              thickness: 1,
            ),
            SizedBox(height: 12.h),
            MenuItem(
              onTap: () {
                Get.toNamed(Routes.CONTACTS);
              },
              title: LocaleKeys.AccountPage_contacts.tr,
              icon: Assets.svg.contactsIcon.svg(
                color: const Color(0xFF039200),
              ),
              iconBackgroundColor: const Color(0xFFE4FFE4),
            ),
            MenuItem(
              onTap: () {
                controller.logout();
              },
              title: LocaleKeys.AccountPage_logout.tr,
              icon: Icon(
                Icons.logout,
                color: Color(
                  0xFF039200,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountOption({
    required String title,
    required Widget icon,
    required Color iconBackgroundColor,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconBackgroundColor,
              ),
              child: icon,
            ),
            CustomSizes.mediumSizedBoxWidth,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kDarkBlueColor),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kTextSoftBlueColor),
                    ),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}
