import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/new_call/widgets/grouped_contact_list_widget.dart';
import 'package:heyo/app/modules/calls/new_call/widgets/search_result_widget.dart';
import 'package:heyo/modules/call/presentation/add_participate/add_participate_controller.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/modules/call/presentation/add_participate/widgets/selected_user_chip.dart';

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
          Padding(
            padding: CustomSizes.mainContentPadding,
            child: Obx(() {
              if (controller.inputController.value.text.isNotEmpty) {
                return const SearchResultWidget();
              } else {
                return const GroupedContactListWidget();
              }
            }),
          ),
        ],
      ),
    );
  }
}
