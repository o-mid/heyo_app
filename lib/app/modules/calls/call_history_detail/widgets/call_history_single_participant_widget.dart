import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/call_history_detail/controllers/call_history_detail_controller.dart';
import 'package:heyo/app/modules/calls/call_history_detail/widgets/history_call_log_widget.dart';
import 'package:heyo/app/modules/calls/call_history_detail/widgets/single_participant_header_widget.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/messages_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/messaging_participant_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/animate_list_widget.dart';
import 'package:heyo/app/modules/shared/widgets/appbar_widget.dart';
import 'package:heyo/app/modules/shared/widgets/circle_icon_button.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class CallHistorySingleParticipantWidget
    extends GetView<CallHistoryDetailController> {
  const CallHistorySingleParticipantWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        backgroundColor: COLORS.kGreenMainColor,
        title: LocaleKeys.CallHistory_callParticipant.tr,
        actions: [
          Obx(() {
            if (controller.recentCalls.isNotEmpty) {
              return InkWell(
                onTap: () {
                  controller.openAppBarActionBottomSheet(
                    participant:
                        controller.callHistoryModel!.value!.participants[0],
                  );
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(26.w, 0, 26.w, 0),
                  child: Assets.svg.verticalMenuIcon.svg(),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        if (controller.callHistoryModel!.value!.participants.isEmpty) {
          return const SizedBox.shrink();
        }
        return AnimateListWidget(
          children: [
            const SingleParticipantHeder(),
            Container(color: COLORS.kBrightBlueColor, height: 8.h),
            SizedBox(height: 24.h),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                LocaleKeys.CallHistory_appbar.tr,
                style: TEXTSTYLES.kLinkSmall
                    .copyWith(color: COLORS.kTextBlueColor),
              ),
            ),
            CustomSizes.smallSizedBoxHeight,
            ...controller.recentCalls.map(
              (call) => Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: HistoryCallLogWidget(call: call),
              ),
            ),
            CustomSizes.mediumSizedBoxHeight,
          ],
        );
      }),
    );
  }
}
