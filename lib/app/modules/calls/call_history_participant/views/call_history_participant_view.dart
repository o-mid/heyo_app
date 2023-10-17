import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/call_history_participant/controllers/call_history_participant_controller.dart';
import 'package:heyo/app/modules/calls/call_history_participant/widgets/history_call_log_widget.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/messages_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/circle_icon_button.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class CallHistoryParticipantView
    extends GetView<CallHistoryParticipantController> {
  const CallHistoryParticipantView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: COLORS.kGreenMainColor,
        title: Text(
          LocaleKeys.CallHistory_appbar.tr,
          style: TEXTSTYLES.kHeaderLarge,
        ),
        actions: [
          Obx(() {
            if (controller.calls.isNotEmpty) {
              return Padding(
                padding: EdgeInsets.only(right: 26.w),
                child: GestureDetector(
                  onTap: () {},
                  child: Assets.svg.verticalMenuIcon.svg(),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Obx(() {
            if (controller.user.value == null) {
              return const SizedBox.shrink();
            }
            return Column(
              children: [
                SizedBox(height: 40.h),
                CustomCircleAvatar(
                  url: controller.user.value!.iconUrl,
                  size: 64,
                ),
                CustomSizes.mediumSizedBoxHeight,
                GestureDetector(
                  onTap: () => controller.saveCoreIdToClipboard(),
                  child: Text(
                    controller.user.value!.name,
                    style: TEXTSTYLES.kHeaderLarge
                        .copyWith(color: COLORS.kDarkBlueColor),
                  ),
                ),
                SizedBox(height: 4.h),
                GestureDetector(
                  onTap: () => controller.saveCoreIdToClipboard(),
                  child: Text(
                    controller.user.value!.coreId.shortenCoreId,
                    style: TEXTSTYLES.kBodySmall
                        .copyWith(color: COLORS.kTextSoftBlueColor),
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
                          enableVideo: false,
                          isAudioCall: true,
                          members: [controller.args.coreId],
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
                          members: [controller.args.coreId],
                          enableVideo: true,
                          isAudioCall: false,
                        ),
                      ),
                      icon: Assets.svg.videoCallIcon
                          .svg(color: COLORS.kDarkBlueColor),
                    ),
                    SizedBox(width: 24.w),
                    // Todo Omid : add go to messaging screen
                    CircleIconButton(
                      backgroundColor: COLORS.kBrightBlueColor,
                      padding: EdgeInsets.all(14.w),
                      onPressed: () {
                        Get.toNamed(
                          Routes.MESSAGES,
                          arguments: MessagesViewArgumentsModel(
                            coreId: controller.user.value!.coreId,
                            iconUrl: controller.user.value!.iconUrl,
                            connectionType: MessagingConnectionType.internet,
                          ),
                        );
                      },
                      icon: Assets.svg.chatOutlined
                          .svg(color: COLORS.kDarkBlueColor),
                    ),
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
                ...controller.calls.map(
                  (call) => Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    child: HistoryCallLogWidget(call: call),
                  ),
                ),
                CustomSizes.mediumSizedBoxHeight,
              ],
            );
          }),
        ),
      ),
    );
  }
}
