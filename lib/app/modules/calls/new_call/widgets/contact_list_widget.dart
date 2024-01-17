import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/new_call/controllers/new_call_controller.dart';
import 'package:heyo/app/modules/calls/new_call/widgets/grouped_contact_list_widget.dart';
import 'package:heyo/app/modules/calls/new_call/widgets/search_result_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/contact_list_with_header.dart';
import 'package:heyo/generated/locales.g.dart';

class ContactListWidget extends GetView<NewCallController> {
  const ContactListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const Divider(thickness: 8, color: COLORS.kBrightBlueColor),
          //* List of contacts
          Expanded(
            child: Padding(
              padding: CustomSizes.mainContentPadding,
              child: Obx(() {
                if (controller.inputText.value.isNotEmpty) {
                  return const SearchResultWidget();
                } else {
                  return const GroupedContactListWidget();
                }
              }),
            ),
          ),
        ],
      ),
    );
    //return Padding(
    //  padding: CustomSizes.mainContentPadding,
    //  child: Column(
    //    crossAxisAlignment: CrossAxisAlignment.start,
    //    children: [
    //      CustomSizes.smallSizedBoxHeight,
    //      const Divider(thickness: 8, color: COLORS.kBrightBlueColor),
    //      Obx(() {
    //        if (controller.inputText.value.isNotEmpty) {
    //          return Column(
    //            children: [
    //              CustomSizes.largeSizedBoxHeight,
    //              Padding(
    //                padding: CustomSizes.mainContentPadding,
    //                child: ContactListWithHeader(
    //                  contacts: controller.searchItems.toList(),
    //                  searchMode: controller.inputText.isNotEmpty,
    //                  showAudioCallButton: true,
    //                  showVideoCallButton: true,
    //                ),
    //              ),
    //            ],
    //          );
    //        } else {
    //          return Column(
    //            children: [
    //              SizedBox(height: 24.h),
    //              Padding(
    //                padding: EdgeInsets.symmetric(horizontal: 20.w),
    //                child: Text(
    //                  LocaleKeys.NewCallPage_contactListHeader.trParams(
    //                    {'count': controller.searchItems.length.toString()},
    //                  ),
    //                  style: TEXTSTYLES.kLinkSmall.copyWith(
    //                    color: COLORS.kTextSoftBlueColor,
    //                  ),
    //                ),
    //              ),
    //            ],
    //          );
    //        }
    //      }),
    //    ],
    //  ),
    //);
  }
}
