import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/utils/constants/colors.dart';
import '../../shared/widgets/chip_widget.dart';
import '../controllers/add_participate_controller.dart';

class SelectedUserChip extends StatelessWidget {
  const SelectedUserChip({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddParticipateController>();

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
                    avatarUrl: user.iconUrl,
                    label: user.name,
                    onDelete: () {
                      controller.addUser(user); // Remove the user from the list
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
