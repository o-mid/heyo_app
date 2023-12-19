import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/call_history/controllers/call_history_controller.dart';
import 'package:heyo/app/modules/calls/call_history/widgets/call_history_avatar_widget.dart';
import 'package:heyo/app/modules/calls/call_history/widgets/group_call_circle_avatar.dart';
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

class CallHistoryListTitleWidget extends GetView<CallHistoryController> {
  const CallHistoryListTitleWidget({required this.call, super.key});
  final CallHistoryModel call;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(
        Routes.USER_CALL_HISTORY,
        arguments: UserCallHistoryViewArgumentsModel(
          callId: call.callId,
          participants: call.participants.map((e) => e.coreId).toList(),
        ),
      ),
      child: SlidableWidget(
        key: Key(call.callId),
        onDismissed: () => controller.deleteCall(call),
        confirmDismiss: () => controller.showDeleteCallDialog(call),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: Row(
            children: [
              CallHistoryAvatarWidget(callHistoryModel: call),
              CustomSizes.mediumSizedBoxWidth,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      call.participants
                          .map((element) => element.name)
                          .toList()
                          .join(', '),
                      style: TEXTSTYLES.kChatName.copyWith(
                        color: COLORS.kDarkBlueColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(height: 4.h),
                    CallStatusIconAndDate(call: call),
                  ],
                ),
              ),
              //const Spacer(),
              CustomSizes.mediumSizedBoxWidth,
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
