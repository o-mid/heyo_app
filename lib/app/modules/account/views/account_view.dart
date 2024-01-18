import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/account/controllers/account_controller.dart';
import 'package:heyo/app/modules/account/widgets/account_header_widget.dart';
import 'package:heyo/app/modules/account/widgets/account_menu_item_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/widgets/animate_list_widget.dart';
import 'package:heyo/app/modules/shared/widgets/appbar_widget.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLORS.kAppBackground,
      appBar: AppBarWidget(title: LocaleKeys.AccountPage_appBarTitle.tr),
      body: AnimateListWidget(
        children: [
          const AccountHeaderWidget(),
          SizedBox(height: 12.h),
          MenuItemWidget(
            onTap: () => Get.toNamed(Routes.CONTACTS),
            title: LocaleKeys.AccountPage_contacts.tr,
            icon: Assets.svg.contactsIcon.svg(
              color: const Color(0xFF039200),
            ),
            iconBackgroundColor: const Color(0xFFE4FFE4),
          ),
          MenuItemWidget(
            onTap: () => controller.logout(),
            title: LocaleKeys.AccountPage_logout.tr,
            icon: const Icon(
              Icons.logout,
              size: 16,
              color: Color(0xFF039200),
            ),
            iconBackgroundColor: const Color(0xFFE4FFE4),
          ),
        ],
      ),
    );
  }

//  Widget _buildAccountOption({
//    required String title,
//    required Widget icon,
//    required Color iconBackgroundColor,
//    String? subtitle,
//    Widget? trailing,
//    VoidCallback? onTap,
//  }) {
//    return InkWell(
//      onTap: onTap,
//      borderRadius: BorderRadius.circular(8.r),
//      child: Container(
//        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
//        margin: EdgeInsets.symmetric(horizontal: 10.w),
//        child: Row(
//          children: [
//            Container(
//              width: 40.w,
//              height: 40.w,
//              padding: EdgeInsets.all(12.w),
//              decoration: BoxDecoration(
//                shape: BoxShape.circle,
//                color: iconBackgroundColor,
//              ),
//              child: icon,
//            ),
//            CustomSizes.mediumSizedBoxWidth,
//            Expanded(
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: [
//                  Text(
//                    title,
//                    style: TEXTSTYLES.kLinkBig
//                        .copyWith(color: COLORS.kDarkBlueColor),
//                  ),
//                  if (subtitle != null)
//                    Text(
//                      subtitle,
//                      style: TEXTSTYLES.kBodySmall
//                          .copyWith(color: COLORS.kTextSoftBlueColor),
//                    ),
//                ],
//              ),
//            ),
//            if (trailing != null) trailing,
//          ],
//        ),
//      ),
//    );
//  }
}
