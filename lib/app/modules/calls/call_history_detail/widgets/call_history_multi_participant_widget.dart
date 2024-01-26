import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/call_history_detail/controllers/call_history_detail_controller.dart';
import 'package:heyo/app/modules/calls/call_history_detail/widgets/call_history_detail_avatar_widget.dart';
import 'package:heyo/app/modules/calls/call_history_detail/widgets/call_history_detail_list_tile_widget.dart';
import 'package:heyo/app/modules/calls/call_history_detail/widgets/multi_participant_header_widget.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/utils/extensions/datetime.extension.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/animate_list_widget.dart';
import 'package:heyo/app/modules/shared/widgets/appbar_widget.dart';
import 'package:heyo/app/modules/shared/widgets/circle_icon_button.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class CallHistoryMultiParticipantWidget
    extends GetView<CallHistoryDetailController> {
  const CallHistoryMultiParticipantWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(() {
        if (controller.callHistoryModel!.value!.participants.isEmpty) {
          return const SizedBox.shrink();
        }
        return AnimateListWidget(
          children: [
            const MultiParticipantHeaderWidget(),
            SizedBox(height: 40.h),
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
            ...controller.callHistoryModel!.value!.participants
                .map((participant) {
              return CallHistoryDetailListTileWidget(
                coreId: participant.coreId,
                name: participant.name,
                trailing: participant.startDate
                    .formattedDifference(participant.endDate),
              );
            }),
            CustomSizes.mediumSizedBoxHeight,
          ],
        );
      }),
    );
  }
}
