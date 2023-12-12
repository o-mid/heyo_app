import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
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
                // TODO :
                onTap: () {
                  //Todo:  Blocking Implimentation
                  Get.rawSnackbar(
                    messageText: Text(
                      "Blocking Contacts feature is in development phase",
                      style: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kDarkBlueColor),
                      textAlign: TextAlign.center,
                    ),
                    //  padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
                    backgroundColor: COLORS.kAppBackground,
                    snackPosition: SnackPosition.TOP,
                    snackStyle: SnackStyle.FLOATING,
                    margin: const EdgeInsets.only(top: 20),
                    boxShadows: [
                      BoxShadow(
                        color: const Color(0xFF466087).withOpacity(0.1),
                        offset: const Offset(0, 3),
                        blurRadius: 10,
                      ),
                    ],
                    borderRadius: 8,
                  );
                  return;
                },
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
        Get.find<UserPreview>().openUserPreview(
          userModel: contact,
        );
      },
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          children: [
            CustomCircleAvatar(coreId: contact.coreId, size: 40),
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
