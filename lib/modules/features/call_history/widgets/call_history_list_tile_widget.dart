import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/shared/data/models/call_history_model/call_history_model.dart';
import 'package:heyo/app/modules/calls/shared/widgets/call_status_icon_and_date.dart';
import 'package:heyo/app/modules/shared/data/models/user_call_history_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/slidable_widget.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:heyo/modules/core-ui/widgets/custom_dialog_widget.dart';
import 'package:heyo/modules/features/call_history/controllers/call_history_controller.dart';
import 'package:heyo/modules/features/call_history/models/call_history_view_model/call_history_view_model.dart';
import 'package:heyo/modules/features/call_history/widgets/call_history_avatar_widget.dart';

class CallHistoryListTitleWidget extends GetView<CallHistoryController> {
  const CallHistoryListTitleWidget({required this.call, super.key});
  final CallHistoryViewModel call;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed<void>(
        Routes.USER_CALL_HISTORY,
        arguments: UserCallHistoryViewArgumentsModel(
          callId: call.callId,
          participants: call.participants.map((e) => e.coreId).toList(),
        ),
      ),
      child: SlidableWidget(
        key: Key(call.callId),
        onDismissed: () => controller.deleteCall(call),
        confirmDismiss: () async {
          await showCustomDialog(
            context,
            title: LocaleKeys.HomePage_Calls_deleteAllCallsDialog_title.tr,
            confirmTitle:
                LocaleKeys.HomePage_Calls_deleteAllCallsDialog_delete.tr,
            indicatorIcon:
                Assets.svg.deleteIcon.svg(color: COLORS.kDarkBlueColor),
            onConfirm: () {
              controller.deleteCall(call);
              Get.back<void>();
            },
            onCancel: () => Get.back<void>(),
          );
          return false;
        },
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
