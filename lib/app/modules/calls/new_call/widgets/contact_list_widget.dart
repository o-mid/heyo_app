import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/new_call/controllers/new_call_controller.dart';
import 'package:heyo/app/modules/calls/new_call/widgets/grouped_contact_list_widget.dart';
import 'package:heyo/app/modules/calls/new_call/widgets/search_result_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';

class ContactListWidget extends GetView<NewCallController> {
  const ContactListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        children: [
          const Divider(thickness: 8, color: COLORS.kBrightBlueColor),
          Padding(
            padding: CustomSizes.mainContentPadding,
            child: Obx(() {
              if (controller.inputText.value.isNotEmpty) {
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
