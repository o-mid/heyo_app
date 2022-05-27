import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/generated/assets.gen.dart';

// Todo: replace this with remote video webrtc
class CalleeVideoWidget extends StatelessWidget {
  const CalleeVideoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CallController>();
    return GestureDetector(
      onTap: controller.toggleImmersiveMode,
      child: Assets.png.callee.image(),
    );
  }
}
