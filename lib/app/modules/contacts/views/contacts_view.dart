import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/contacts/controllers/contacts_controller.dart';
import 'package:heyo/app/modules/contacts/widgets/blocked_contact_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/animate_list_widget.dart';
import 'package:heyo/app/modules/shared/widgets/appbar_widget.dart';
import 'package:heyo/app/modules/shared/widgets/user_list_tile_widget.dart';
import 'package:heyo/generated/locales.g.dart';

class ContactsView extends GetView<ContactsController> {
  const ContactsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: LocaleKeys.ContactsPage_appBarTitle.tr,
      ),
      body: Obx(() {
        return AnimateListWidget(
          children: [
            const BlockedContactWidget(),
            const Divider(thickness: 8, color: COLORS.kBrightBlueColor),
            CustomSizes.largeSizedBoxHeight,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                LocaleKeys.ContactsPage_contactListHeader.trParams(
                  {'count': controller.contacts.length.toString()},
                ),
                style: TEXTSTYLES.kLinkSmall.copyWith(
                  color: COLORS.kTextSoftBlueColor,
                ),
              ),
            ),
            CustomSizes.smallSizedBoxHeight,
            ...controller.contacts.map(
              (contact) => UserListTileWidget(
                coreId: contact.coreId,
                name: contact.name,
                showAudioCallButton: true,
                showVideoCallButton: true,
              ),
            ),
          ],
        );
      }),
    );
  }

//  Widget _buildContact({
//    required String coreId,
//    required String name,
//    required bool isVerified,
//    required bool isContact,
//  }) {
//    return InkWell(
//      onTap: () {
//        Get.find<UserPreview>().openUserPreview(
//          coreId: coreId,
//          name: name, // Assuming you want to display the nickname as the name
//          isVerified: isVerified,
//          isContact: isContact,
//        );
//      },
//      borderRadius: BorderRadius.circular(8.r),
//      child: Container(
//        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
//        margin: EdgeInsets.symmetric(horizontal: 10.w),
//        child: Row(
//          children: [
//            CustomCircleAvatar(coreId: coreId, size: 40),
//            CustomSizes.mediumSizedBoxWidth,
//            Expanded(
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: [
//                  Text(
//                    name,
//                    style: TEXTSTYLES.kChatName
//                        .copyWith(color: COLORS.kDarkBlueColor),
//                  ),
//                  Text(
//                    coreId
//                        .shortenCoreId, // Assuming you have a method to shorten the coreId
//                    style: TEXTSTYLES.kBodySmall
//                        .copyWith(color: COLORS.kTextSoftBlueColor),
//                  ),
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
}
