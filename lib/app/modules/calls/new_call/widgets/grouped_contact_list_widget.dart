import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/new_call/controllers/new_call_controller.dart';
import 'package:heyo/app/modules/new_chat/widgets/user_widget.dart';
import 'package:heyo/app/modules/shared/widgets/animate_list_widget.dart';
import 'package:heyo/app/modules/shared/widgets/list_header_widget.dart';

class GroupedContactListWidget extends GetView<NewCallController> {
  const GroupedContactListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AnimateListWidget(
        children: controller.groupedContact.keys.map((key) {
          return Obx(() {
            final contactsForChar = controller.groupedContact[key]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListHeaderWidget(title: key),
                Column(
                  children: contactsForChar
                      .map(
                        (p) => Column(
                          children: [
                            const SizedBox(height: 10),
                            UserWidget(
                              coreId: p.coreId,
                              name: p.name,
                              walletAddress: p.coreId,
                              showAudioCallButton: true,
                              showVideoCallButton: true,
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ],
            );
          });
        }).toList(),
      );

      //return ListView.builder(
      //  shrinkWrap: true,
      //  itemCount: controller.groupedContact.length,
      //  itemBuilder: (context, index) {
      //    return
      //  },
      //);
    });
  }
}
