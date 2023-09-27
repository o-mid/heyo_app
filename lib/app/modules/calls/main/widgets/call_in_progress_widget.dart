import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/app/modules/calls/main/widgets/group_call_widget.dart';
import 'package:heyo/app/modules/calls/main/widgets/peer_call_widget.dart';

class CallInProgressWidget extends GetView<CallController> {
  const CallInProgressWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isGroupCall.isTrue) {
        return const GroupCallWidget();
      } else {
        return const PeerCallWidget();
      }
    });
  }
}
