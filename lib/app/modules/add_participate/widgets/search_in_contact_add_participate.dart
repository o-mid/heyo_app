import 'package:flutter/material.dart';
import 'package:heyo/app/modules/add_participate/controllers/add_participate_controller.dart';
import 'package:heyo/app/modules/add_participate/widgets/contact_list_with_header_add_participate.dart';
import 'package:heyo/app/modules/add_participate/widgets/selected_user_chip.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';

class SearchInContactsBody extends StatelessWidget {
  const SearchInContactsBody(this.controller, {super.key});

  final AddParticipateController controller;
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
