import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/modules/call/presentation/add_participate/add_participate_controller.dart';
import 'package:heyo/app/modules/shared/widgets/animate_list_widget.dart';
import 'package:heyo/app/modules/shared/widgets/list_header_widget.dart';
import 'package:heyo/modules/call/presentation/add_participate/widgets/addable_user_widget.dart';

class GroupedContactListWidget extends GetView<AddParticipateController> {
  const GroupedContactListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AnimateListWidget(
        children: controller.groupedParticipateItems.keys.map((key) {
          return Obx(() {
            final contactsForChar = controller.groupedParticipateItems[key]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!controller.allSubgroupSelected(key))
                  ListHeaderWidget(title: key),
                Column(
                  children: contactsForChar
                      .map((p) => AddableUserWidget(user: p))
                      .toList(),
                ),
              ],
            );
          });
        }).toList(),
      );
    });
  }
}
