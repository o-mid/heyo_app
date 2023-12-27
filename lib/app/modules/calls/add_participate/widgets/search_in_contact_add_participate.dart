import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/add_participate/controllers/add_participate_controller.dart';
import 'package:heyo/app/modules/calls/add_participate/widgets/contact_list_with_header_add_participate.dart';
import 'package:heyo/app/modules/calls/add_participate/widgets/selected_user_chip.dart';
import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';

class SearchInContactsBody extends GetView<CallController> {
  const SearchInContactsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomSizes.smallSizedBoxHeight,
        const SelectedUserChip(),
        const Divider(thickness: 8, color: COLORS.kBrightBlueColor),
        CustomSizes.largeSizedBoxHeight,
        Padding(
          padding: CustomSizes.mainContentPadding,
          child: ContactListWithHeaderAddParticipate(
            contacts: controller.searchItems,
            searchMode: controller.inputController.text.isNotEmpty,
          ),
        ),
      ],
    );
  }
}
