import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/add_participate/controllers/add_participate_controller.dart';
import 'package:heyo/app/modules/calls/add_participate/widgets/grouped_contact_list_widget.dart';
import 'package:heyo/app/modules/calls/add_participate/widgets/search_result_widget.dart';
import 'package:heyo/app/modules/calls/add_participate/widgets/selected_user_chip.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';

class ParticipantListWidget extends GetView<AddParticipateController> {
  const ParticipantListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const SelectedUserChip(),
          const Divider(thickness: 8, color: COLORS.kBrightBlueColor),
          //* List of participant
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
  }
}
