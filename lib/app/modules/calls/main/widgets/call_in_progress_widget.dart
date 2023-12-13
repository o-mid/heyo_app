import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/app/modules/calls/main/widgets/group_call_widget.dart';
import 'package:heyo/app/modules/calls/main/widgets/peer_call_widget.dart';

class CallInProgressWidget extends GetView<CallController> {
  const CallInProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.switchFullSCreenMode(),
      child: Obx(() {
        if (controller.isGroupCall.value) {
          return const GroupCallWidget();
        } else {
          return const PeerCallWidget();
        }
      }),
    );
  }
}
