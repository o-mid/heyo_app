import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/app/modules/shared/widgets/chip_widget.dart';

class SelectedUserChip extends GetView<CallController> {
  const SelectedUserChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Row(
          children: [
            Wrap(
              spacing: 8,
              children: controller.selectedUser.map(
                (user) {
                  return ChipWidget(
                    coreId: user.coreId,
                    label: user.name,
                    onDelete: () {
                      //* Remove the user from the list
                      controller.selectUser(user);
                    },
                  );
                },
              ).toList(),
            ),
          ],
        ),
      );
    });
  }
}
