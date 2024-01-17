import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/add_participate/controllers/add_participate_controller.dart';
import 'package:heyo/app/modules/calls/add_participate/widgets/addable_user_widget.dart';
import 'package:heyo/app/modules/shared/widgets/list_header_widget.dart';

class GroupedContactListWidget extends GetView<AddParticipateController> {
  const GroupedContactListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: controller.groupedParticipateItems.length,
          itemBuilder: (context, index) {
            return Obx(() {
              final firstChar =
                  controller.groupedParticipateItems.keys.elementAt(index);
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
        ),
      );
    });
  }
}
