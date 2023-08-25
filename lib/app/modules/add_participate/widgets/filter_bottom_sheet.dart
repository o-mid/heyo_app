import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/locales.g.dart';

void openFiltersBottomSheet({required controller}) {
  Get.bottomSheet(
    Container(
      padding: CustomSizes.mainContentPadding,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomSizes.smallSizedBoxHeight,
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                // Close the bottom sheet
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.arrow_back,
                  color: COLORS.kDarkBlueColor,
                ),
                label: Text(
                  LocaleKeys.newChat_buttons_filter.tr,
                  style: TEXTSTYLES.kHeaderLarge
                      .copyWith(color: COLORS.kDarkBlueColor),
                ),
              ),
            ),
            Obx(() {
              return ListView.builder(
                itemCount: controller.filters.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return CheckboxListTile(
                      title: Text(
                        controller.filters[index].title,
                        style: TEXTSTYLES.kLinkBig
                            .copyWith(color: COLORS.kDarkBlueColor),
                      ),
                      value: controller.filters[index].isActive.value,
                      onChanged: (Value) {
                        if (Value != null) {
                          controller.filters[index].isActive.value = Value;

                          controller.filters.refresh();

                          controller.nearbyUsers.refresh();
                        }
                      },
                      contentPadding: EdgeInsets.zero,
                      activeColor: COLORS.kGreenMainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      controlAffinity: ListTileControlAffinity.leading);
                },
              );
            }),
          ]),
    ),
    backgroundColor: COLORS.kWhiteColor,
    isDismissible: true,
    enableDrag: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(20),
      ),
    ),
  );
}
