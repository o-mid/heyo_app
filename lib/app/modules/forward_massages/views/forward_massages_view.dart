import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/forward_massages/widgets/contacts_widget.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/inputs/custom_text_field.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';

import '../../../../generated/locales.g.dart';
import '../../new_chat/widgets/user_widget.dart';
import '../../shared/widgets/list_header_widget.dart';
import '../controllers/forward_massages_controller.dart';
import '../widgets/recent_contacts_widget.dart';

class ForwardMassagesView extends GetView<ForwardMassagesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            LocaleKeys.forwardMassagesPage_appbar.tr,
            style: TEXTSTYLES.kHeaderLarge.copyWith(color: COLORS.kWhiteColor),
          ),
          leading: IconButton(
            onPressed: (() => Get.back()),
            icon: const Icon(
              Icons.arrow_back,
              color: COLORS.kWhiteColor,
            ),
          ),
          centerTitle: false,
          automaticallyImplyLeading: true,
          backgroundColor: COLORS.kGreenMainColor,
        ),
        backgroundColor: COLORS.kWhiteColor,
        body: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  CustomSizes.largeSizedBoxHeight,
                  Padding(
                    padding: CustomSizes.contentPaddingWidth,
                    child: FocusScope(
                      child: Focus(
                        onFocusChange: (focus) =>
                            controller.isTextInputFocused.value = focus,
                        child: CUSTOMTEXTFIELD(
                          textController: controller.inputController,
                          labelText:
                              LocaleKeys.forwardMassagesPage_textInput.tr,
                        ),
                      ),
                    ),
                  ),
                  CustomSizes.largeSizedBoxHeight,
                  Divider(
                    color: COLORS.kBrightBlueColor,
                    thickness: 8,
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //dont show recent Contacts when the input is focused and its searching for users
                      controller.isTextInputFocused.value
                          ? SizedBox()
                          : recentContactsWidget(users: controller.users),
                      contactsWidget(
                        isTextInputFocused: controller.isTextInputFocused,
                        searchSuggestions: controller.searchSuggestions,
                      ),
                      CustomSizes.largeSizedBoxHeight,
                    ],
                  ),
                ),
              )
            ],
          );
        }));
  }
}
