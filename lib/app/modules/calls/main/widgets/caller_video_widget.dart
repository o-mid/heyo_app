import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/widgets/circle_icon_button.dart';
import 'package:heyo/generated/assets.gen.dart';

// Todo: Replace this with local video webrtc
class CallerVideoWidget extends StatefulWidget {
  const CallerVideoWidget({super.key});

  @override
  State<CallerVideoWidget> createState() => _CallerVideoWidgetState();
}

class _CallerVideoWidgetState extends State<CallerVideoWidget> {
  bool showOptions = false;
  late CallController controller;

  @override
  initState() {
    super.initState();
    controller = Get.find<CallController>();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showOptions = !showOptions;
        });
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Assets.png.caller.image(),
          if (showOptions)
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Row(
                children: [
                  const Spacer(),
                  _buildViewOptionButton(
                    onPressed: () => controller.updateCallViewType(CallViewType.column),
                    icon: Assets.svg.stackVertical.svg(),
                  ),
                  const Spacer(),
                  _buildViewOptionButton(
                    onPressed: () => controller.updateCallViewType(CallViewType.row),
                    icon: Assets.svg.stackHorizontal.svg(),
                  ),
                  const Spacer(),
                  _buildViewOptionButton(
                    onPressed: () => controller.updateCallViewType(CallViewType.stack),
                    icon: Assets.svg.fullScreen.svg(),
                  ),
                  const Spacer(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildViewOptionButton({required Widget icon, VoidCallback? onPressed}) {
    return Expanded(
      flex: 3,
      child: CircleIconButton(
        onPressed: onPressed,
        padding: const EdgeInsets.all(6.0),
        backgroundColor: COLORS.kCallPageDarkGrey.withOpacity(0.8),
        icon: icon,
      ),
    );
  }
}
