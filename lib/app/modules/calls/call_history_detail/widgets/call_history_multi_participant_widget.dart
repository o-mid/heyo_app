import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/call_history_detail/controllers/call_history_detail_controller.dart';
import 'package:heyo/app/modules/calls/call_history_detail/widgets/call_history_detail_avatar_widget.dart';
import 'package:heyo/app/modules/calls/call_history_detail/widgets/call_history_detail_list_tile_widget.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/datetime.extension.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
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
        if (controller.participants.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          children: [
            SizedBox(height: 40.h),
            CallHistoryDetailAvatarWidget(
              participants:
                  controller.participants.map((e) => e.coreId).toList(),
            ),
            CustomSizes.mediumSizedBoxHeight,
            Text(
              controller.participants
                  .map((element) => element.name)
                  .toList()
                  .join(', '),
              style: TEXTSTYLES.kHeaderLarge
                  .copyWith(color: COLORS.kDarkBlueColor),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(height: 4.h),
            Text(
              controller.participants
                  .map((element) => element.name)
                  .toList()
                  .join(', '),
              style: TEXTSTYLES.kBodySmall
                  .copyWith(color: COLORS.kTextSoftBlueColor),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
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
                  icon: Assets.svg.audioCallIcon
                      .svg(color: COLORS.kDarkBlueColor),
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
                  icon: Assets.svg.videoCallIcon
                      .svg(color: COLORS.kDarkBlueColor),
                ),
                SizedBox(width: 24.w),
                // Todo Omid : add go to messaging screen
                //CircleIconButton(
                //  backgroundColor: COLORS.kBrightBlueColor,
                //  padding: EdgeInsets.all(14.w),
                //  onPressed: () {
                //    Get.toNamed(
                //      Routes.MESSAGES,
                //      arguments: MessagesViewArgumentsModel(
                //        coreId: controller.participants[0].coreId,
                //        connectionType: MessagingConnectionType.internet,
                //        participants: [
                //          MessagingParticipantModel(
                //            coreId: controller.participants[0].coreId,
                //          ),
                //        ],
                //      ),
                //    );
                //  },
                //  icon:
                //      Assets.svg.chatOutlined.svg(color: COLORS.kDarkBlueColor),
                //),
              ],
            ),
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
            ...controller.participants.map((participant) {
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
