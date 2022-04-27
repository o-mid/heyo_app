import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/forward_massages/widgets/contacts_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/inputs/custom_text_field.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import '../../../../generated/assets.gen.dart';
import '../../../../generated/locales.g.dart';
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
                  const Divider(
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
                          ? const SizedBox()
                          : recentContactsWidget(
                              users: controller.users,
                              userSelect: controller.setSelectedUser),
                      contactsWidget(
                        isTextInputFocused: controller.isTextInputFocused,
                        searchSuggestions: controller.searchSuggestions,
                      ),
                      CustomSizes.largeSizedBoxHeight,
                    ],
                  ),
                ),
              ),
              controller.selectedUserName.isNotEmpty
                  ? Container(
                      decoration: const BoxDecoration(
                        color: COLORS.kComposeMessageBackgroundColor,
                        border: const Border(
                          top: BorderSide(
                            width: 1,
                            color: COLORS.kComposeMessageBorderColor,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 12.h, horizontal: 20.w),
                      child: Row(
                        children: [
                          Assets.svg.forwardTo.svg(
                            width: 19.w,
                            height: 17.w,
                            color: COLORS.kDarkBlueColor,
                          ),
                          CustomSizes.mediumSizedBoxWidth,
                          Expanded(
                              child: Column(
                            children: [
                              Text(
                                "Forward to " +
                                    controller.selectedUserName.value,
                              )
                            ],
                          ))
                        ],
                      ),
                    )
                  : const SizedBox(),
            ],
          );
        }));
  }
}
