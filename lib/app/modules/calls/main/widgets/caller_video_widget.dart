import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/widgets/circle_icon_button.dart';
import 'package:heyo/generated/assets.gen.dart';

// Todo: Replace this with local video webrtc
class CallerVideoWidget extends StatelessWidget {
  const CallerVideoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CallController>(
        id: "caller",
        builder: (controller) {
          RTCVideoRenderer localVideRenderer =
              controller.getLocalVideRenderer();

          return GestureDetector(
            onTap: () => controller.changeCallerOptions(),
            onDoubleTap: controller.flipVideoPositions,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Flexible(
                    child: Container(
                  key: const Key('remote'),
                  margin: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(color: Colors.transparent),
                  child: RTCVideoView(localVideRenderer,
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      mirror: true),
                )),
                if (controller.showCallerOptions.value)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Spacer(),
                            _buildViewOptionButton(
                              onPressed: () => controller
                                  .updateCallViewType(CallViewType.column),
                              icon: Assets.svg.stackVertical.svg(),
                            ),
                            const Spacer(),
                            _buildViewOptionButton(
                              onPressed: () => controller
                                  .updateCallViewType(CallViewType.row),
                              icon: Assets.svg.stackHorizontal.svg(),
                            ),
                            const Spacer(),
                            _buildViewOptionButton(
                              onPressed: () => controller
                                  .updateCallViewType(CallViewType.stack),
                              icon: Assets.svg.fullScreen.svg(),
                            ),
                            const Spacer(),
                          ],
                        ),
                        SizedBox(
                          height:
                              controller.isVideoPositionsFlipped.value ? 16 : 0,
                        )
                      ],
                    ),
                  ),
              ],
            ),
          );
        });
  }

  Widget _buildViewOptionButton(
      {required Widget icon, VoidCallback? onPressed}) {
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
