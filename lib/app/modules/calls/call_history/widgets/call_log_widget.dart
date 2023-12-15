import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/call_history/controllers/call_history_controller.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_history_model/call_history_model.dart';
import 'package:heyo/app/modules/calls/shared/widgets/call_status_icon_and_date.dart';
import 'package:heyo/app/modules/shared/data/models/user_call_history_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';
import 'package:heyo/app/modules/shared/widgets/slidable_widget.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/assets.gen.dart';

class CallLogWidget extends GetView<CallHistoryController> {
  const CallLogWidget({required this.call, super.key});
  final CallHistoryModel call;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //TODO:(Aliazim) add index while pushing
        Get.toNamed(
          Routes.USER_CALL_HISTORY,
          arguments: UserCallHistoryViewArgumentsModel(
            callId: call.callId,
            participants: call.participants.map((e) => e.coreId).toList(),
          ),
        );
      },
      child: SlidableWidget(
        key: Key(call.callId),
        onDismissed: () => controller.deleteCall(call),
        confirmDismiss: () => controller.showDeleteCallDialog(call),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: Row(
            children: [
              CustomCircleAvatar(coreId: call.coreId, size: 40),
              CustomSizes.mediumSizedBoxWidth,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        call.coreId.shortenCoreId,
                        style: TEXTSTYLES.kChatName.copyWith(
                          color: COLORS.kDarkBlueColor,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      //if (call.participants[0].isVerified)
                      //  Assets.svg.verifiedWithBluePadding.svg(
                      //    width: 16.w,
                      //    height: 16.w,
                      //  ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  CallStatusIconAndDate(call: call),
                ],
              ),
              const Spacer(),
              _buildCallTypeIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCallTypeIcon() {
    return Container(
      width: 40.w,
      height: 40.w,
      padding: EdgeInsets.all(10.w),
      decoration: const BoxDecoration(
        color: COLORS.kBrightBlueColor,
        shape: BoxShape.circle,
      ),
      child: call.type == CallType.audio
          ? Assets.svg.audioCallIcon.svg(color: COLORS.kDarkBlueColor)
          : Assets.svg.videoCallIcon.svg(color: COLORS.kDarkBlueColor),
    );
  }
}
