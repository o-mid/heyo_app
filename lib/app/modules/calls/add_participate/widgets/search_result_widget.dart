import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/add_participate/controllers/add_participate_controller.dart';
import 'package:heyo/app/modules/calls/add_participate/widgets/addable_user_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/locales.g.dart';

class SearchResultWidget extends GetView<AddParticipateController> {
  const SearchResultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSizes.smallSizedBoxHeight,
          Text(
            LocaleKeys.newChat_searchResults.tr,
            style: TEXTSTYLES.kLinkSmall.copyWith(
              color: COLORS.kTextSoftBlueColor,
            ),
          ),
          CustomSizes.smallSizedBoxHeight,
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: controller.searchItems.length,
              itemBuilder: (context, index) {
                return AddableUserWidget(
                  user: controller.searchItems[index],
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
