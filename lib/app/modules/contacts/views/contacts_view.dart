import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/new_chat/widgets/user_preview_bottom_sheet.dart';
import 'package:heyo/app/modules/shared/data/models/user_contact.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';
import 'package:heyo/generated/locales.g.dart';

import '../../../../generated/assets.gen.dart';
import '../../shared/controllers/user_preview_controller.dart';
import '../../shared/widgets/item_section_widget.dart';
import '../controllers/contacts_controller.dart';

class ContactsView extends GetView<ContactsController> {
  const ContactsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: COLORS.kGreenMainColor,
        title: Text(
          LocaleKeys.ContactsPage_appBarTitle.tr,
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
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSizes.largeSizedBoxHeight,
              ItemSectionWidget(
                icon: Assets.svg.blockedUser.svg(
                  theme: const SvgTheme(currentColor: COLORS.kStatesErrorColor),
                ),
                iconBackgroundColor: COLORS.kBrightBlueColor,
                title: LocaleKeys.BlockUserPage_BlockedContacts.tr,
                trailing: Text(controller.blockedContacts.length.toString()),
                onTap: () {},
              ),
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
              ...controller.contacts.map((contact) => _buildContact(contact)).toList(),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildContact(
    UserModel contact,
  ) {
    return InkWell(
      onTap: () {
        UserPreview(contactRepository: controller.contactRepo).openUserPreviewBottomSheet(
          userModel: contact,
        );
      },
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          children: [
            CustomCircleAvatar(url: contact.iconUrl, size: 40),
            CustomSizes.mediumSizedBoxWidth,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.nickname,
                    style: TEXTSTYLES.kChatName.copyWith(color: COLORS.kDarkBlueColor),
                  ),
                  Text(
                    contact.coreId.shortenCoreId,
                    style: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kTextSoftBlueColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
