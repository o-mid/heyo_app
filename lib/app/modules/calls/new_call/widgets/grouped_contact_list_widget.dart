import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/new_call/controllers/new_call_controller.dart';
import 'package:heyo/app/modules/new_chat/widgets/user_widget.dart';
import 'package:heyo/app/modules/shared/widgets/list_header_widget.dart';

class GroupedContactListWidget extends GetView<NewCallController> {
  const GroupedContactListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: controller.groupedContact.length,
        itemBuilder: (context, index) {
          return Obx(() {
            final firstChar = controller.groupedContact.keys.elementAt(index);
            final contactsForChar = controller.groupedContact[firstChar]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListHeaderWidget(title: firstChar),
                Column(
                  children: contactsForChar
                      .map(
                        (p) => Column(
                          children: [
                            const SizedBox(height: 10),
                            UserWidget(
                              user: p,
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
        },
      );
    });
  }
}
