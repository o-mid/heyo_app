import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/call_history_detail/controllers/call_history_detail_controller.dart';
import 'package:heyo/app/modules/calls/call_history_detail/widgets/call_history_detail_avatar_widget.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/circle_icon_button.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/assets.gen.dart';

class MultiParticipantHeaderWidget
    extends GetView<CallHistoryDetailController> {
  const MultiParticipantHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 40.h),
        CallHistoryDetailAvatarWidget(
          participants: controller.callHistoryViewModel!.value!.participants
              .map((e) => e.coreId)
              .toList(),
        ),
        CustomSizes.mediumSizedBoxHeight,
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Text(
            controller.callHistoryViewModel!.value!.participants.obs
                .map((element) => element.name)
                .toList()
                .join(', '),
            style:
                TEXTSTYLES.kHeaderLarge.copyWith(color: COLORS.kDarkBlueColor),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        SizedBox(height: 4.h),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Text(
            controller.callHistoryViewModel!.value!.participants
                .map((element) => element.coreId.shortenCoreId)
                .toList()
                .join(', '),
            style: TEXTSTYLES.kBodySmall
                .copyWith(color: COLORS.kTextSoftBlueColor),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        SizedBox(height: 40.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleIconButton(
              backgroundColor: COLORS.kBrightBlueColor,
              padding: EdgeInsets.all(14.w),
              onPressed: () => Get.toNamed(
                Routes.CALL,
                arguments: CallViewArgumentsModel(
                  callId: null,
                  isAudioCall: true,
                  members: controller.args.participants,
                ),
              ),
              icon: Assets.svg.audioCallIcon.svg(color: COLORS.kDarkBlueColor),
            ),
            SizedBox(width: 24.w),
            CircleIconButton(
              backgroundColor: COLORS.kBrightBlueColor,
              padding: EdgeInsets.all(14.w),
              onPressed: () => Get.toNamed(
                Routes.CALL,
                arguments: CallViewArgumentsModel(
                  callId: null,
                  members: controller.args.participants,
                  isAudioCall: false,
                ),
              ),
              icon: Assets.svg.videoCallIcon.svg(color: COLORS.kDarkBlueColor),
            ),
          ],
        ),
      ],
    );
  }
}
