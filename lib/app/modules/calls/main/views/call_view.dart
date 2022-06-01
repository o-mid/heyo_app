import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/main/widgets/call_bottom_sheet_expanded_body.dart';
import 'package:heyo/app/modules/calls/main/widgets/call_bottom_sheet_header.dart';
import 'package:heyo/app/modules/calls/main/widgets/call_in_progress_widget.dart';
import 'package:heyo/app/modules/calls/main/widgets/call_ringing_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/generated/assets.gen.dart';

import '../controllers/call_controller.dart';

class CallView extends GetView<CallController> {
  const CallView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: COLORS.kCallPageDarkGrey,
        appBar: controller.isImmersiveMode.value
            ? null
            : AppBar(
                backgroundColor: COLORS.kCallPageDarkBlue,
                title: Text(
                  controller.args.user.name,
                  style: TEXTSTYLES.kHeaderMedium.copyWith(
                    height: 1.21,
                    fontWeight: FONTS.SemiBold,
                    color: COLORS.kWhiteColor,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: controller.toggleMuteCall,
                    splashRadius: 18,
                    icon: Assets.svg.volumeUp.svg(),
                  ),
                  IconButton(
                    onPressed: controller.switchCamera,
                    splashRadius: 18,
                    icon: Assets.svg.cameraSwitch.svg(),
                  ),
                ],
              ),
        body: ExpandableBottomSheet(
          background: controller.isCallInProgress.value
              ? const CallInProgressWidget()
              : const CallRingingWidget(),
          persistentHeader: controller.isImmersiveMode.value ? null : const CallBottomSheetHeader(),
          expandableContent: controller.isImmersiveMode.value
              ? const SizedBox.shrink()
              : const CallBottomSheetExpandedBody(),
        ),
      );
    });
  }
}

class PScreen extends StatefulWidget {
  @override
  _PScreenState createState() => _PScreenState();
}

class _PScreenState extends State<PScreen> {
  double width = 70.0, height = 70.0;
  double _x = 0;
  double _y = 0;

  Widget circle() {
    return Container(
      width: width,
      height: height,
      child: Center(
        child: Text(
          "Drag",
        ),
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
    );
  }

  Widget draggable() {
    return Positioned(
      left: _x,
      top: _y,
      child: Draggable(
        child: circle(),
        feedback: circle(),
        childWhenDragging: Container(),
        onDragEnd: (dragDetails) {
          setState(
            () {
              _x = dragDetails.offset.dx;
              _x = _x.clamp(0, context.width - 50);
              // We need to remove offsets like app/status bar from Y
              _y = dragDetails.offset.dy - 56 - MediaQuery.of(context).padding.top;
              _y = _y.clamp(0, context.height - 150);
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Drag'),
      leading: BackButton(onPressed: () {
        Navigator.pop(context, false);
      }),
    );
    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: <Widget>[
          draggable(),
          Positioned(left: 0.0, bottom: 0.0, child: circle()),
        ],
      ),
    );
  }
}
