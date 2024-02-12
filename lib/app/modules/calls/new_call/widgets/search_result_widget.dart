import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/new_call/controllers/new_call_controller.dart';
import 'package:heyo/app/modules/new_chat/widgets/user_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/user_list_tile_widget.dart';
import 'package:heyo/generated/locales.g.dart';

class SearchResultWidget extends GetView<NewCallController> {
  const SearchResultWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
        ListView.builder(
          shrinkWrap: true,
          itemCount: controller.searchItems.length,
          itemBuilder: (context, index) {
            return Obx(() {
              return Column(
                children: [
                  const SizedBox(height: 10),
                  UserListTileWidget(
                    coreId: controller.searchItems[index].coreId,
                    name: controller.searchItems[index].name,
                    showAudioCallButton: true,
                    showVideoCallButton: true,
                  ),
                ],
              );
            });
          },
        ),
      ],
    );
  }
}
