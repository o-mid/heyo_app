import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

import '../../chats/data/models/chat_model.dart';
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
              SizedBox(height: 24.h),
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
    UserContact contact,
  ) {
    return InkWell(
      onTap: () {
        openUserPreviewBottomSheet(
          user: UserModel(
            name: contact.nickname,
            icon: contact.icon,
            walletAddress: contact.coreId,
            isContact: true,
            chatModel: ChatModel(
              name: contact.nickname,
              icon: contact.icon,
              id: contact.coreId,
              lastMessage: "",
              timestamp: DateTime.now(),
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          children: [
            CustomCircleAvatar(url: contact.icon, size: 40),
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
