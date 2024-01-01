import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/add_participate/controllers/add_participate_controller.dart';
import 'package:heyo/app/modules/calls/add_participate/widgets/addable_user_widget.dart';
//import 'package:heyo/app/modules/calls/shared/data/models/all_participant_model/all_participant_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/list_header_widget.dart';
import 'package:heyo/generated/locales.g.dart';

class ContactListWithHeaderAddParticipate
    extends GetView<AddParticipateController> {
  const ContactListWithHeaderAddParticipate({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: CustomSizes.mainContentPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              return Column(
                children: [
                  if (controller.inputText.value.isNotEmpty) ...[
                    Text(
                      LocaleKeys.newChat_searchResults.tr,
                      style: TEXTSTYLES.kLinkSmall.copyWith(
                        color: COLORS.kTextSoftBlueColor,
                      ),
                    ),
                    CustomSizes.mediumSizedBoxHeight,
                  ],
                ],
              );
            }),
            Expanded(
              child: controller.inputText.value.isEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.groupedParticipateItems.length,
                      itemBuilder: (context, index) {
                        return Obx(() {
                          final firstChar = controller
                              .groupedParticipateItems.keys
                              .elementAt(index);
                          final contactsForChar =
                              controller.groupedParticipateItems[firstChar]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!controller.allSubgroupSelected(firstChar))
                                ListHeaderWidget(title: firstChar),
                              Column(
                                children: contactsForChar
                                    .map((p) => AddableUserWidget(user: p))
                                    .toList(),
                              ),
                            ],
                          );
                        });
                      },
                    )
                  : ListView.builder(
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
        ),
      ),
    );
  }
}
