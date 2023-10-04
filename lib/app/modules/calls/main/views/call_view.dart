import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/app/modules/calls/main/widgets/call_bottom_sheet_expanded_body.dart';
import 'package:heyo/app/modules/calls/main/widgets/call_bottom_sheet_header.dart';
import 'package:heyo/app/modules/calls/main/widgets/call_in_progress_widget.dart';
import 'package:heyo/app/modules/calls/main/widgets/call_ringing_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/widgets/appbar_widget.dart';
import 'package:heyo/generated/assets.gen.dart';

class CallView extends GetView<CallController> {
  const CallView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: COLORS.kCallPageDarkGrey,
        appBar: controller.isImmersiveMode.value
            ? null
            : AppBarWidget(
                backgroundColor: COLORS.kCallPageDarkBlue,
                title: controller.getConnectedParticipantsName(),
                titleStyle: TEXTSTYLES.kHeaderMedium.copyWith(
                  fontWeight: FONTS.SemiBold,
                  //color: COLORS.kWhiteColor,
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
                  //* Mock for incoming call
                  //IconButton(
                  //  onPressed: controller.incomingMock,
                  //  icon: const Icon(Icons.call_made),
                  //),
                ],
                //bottom: const RecordIndicatorWidget(),
              ),
        body: ExpandableBottomSheet(
          background: controller.localParticipate.value!.isInCall.value
              ? const CallInProgressWidget()
              : const CallRingingWidget(),
          persistentHeader: controller.isImmersiveMode.value
              ? null
              : const CallBottomSheetHeader(),
          expandableContent: controller.isImmersiveMode.value
              ? const SizedBox.shrink()
              : const CallBottomSheetExpandedBody(),
        ),
      );
    });
  }
}
