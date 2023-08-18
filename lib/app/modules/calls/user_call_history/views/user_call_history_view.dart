import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/user_call_history/widgets/history_call_log_widget.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/messages_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/circle_icon_button.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

import '../../../../routes/app_pages.dart';
import '../controllers/user_call_history_controller.dart';

class UserCallHistoryView extends GetView<UserCallHistoryController> {
  const UserCallHistoryView({Key? key}) : super(key: key);

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
            return Column(
              children: [
                SizedBox(height: 40.h),
                CustomCircleAvatar(url: controller.args.user.iconUrl, size: 64),
                CustomSizes.mediumSizedBoxHeight,
                GestureDetector(
                  onTap: () => controller.saveCoreIdToClipboard(),
                  child: Text(
                    controller.args.user.name,
                    style: TEXTSTYLES.kHeaderLarge.copyWith(color: COLORS.kDarkBlueColor),
                  ),
                ),
                SizedBox(height: 4.h),
                GestureDetector(
                  onTap: () => controller.saveCoreIdToClipboard(),
                  child: Text(
                    controller.args.user.walletAddress.shortenCoreId,
                    style: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kTextSoftBlueColor),
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
                            session: null,
                            callId: null,
                            user: controller.args.user,
                            enableVideo: false,
                            isAudioCall: true),
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
                            session: null,
                            callId: null,
                            user: controller.args.user,
                            enableVideo: true,
                            isAudioCall: false),
                      ),
                      icon: Assets.svg.videoCallIcon.svg(color: COLORS.kDarkBlueColor),
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
                              coreId: controller.args.user.coreId,
                              iconUrl: controller.args.user.iconUrl,
                              connectionType: MessagingConnectionType.internet),
                        );
                      },
                      icon: Assets.svg.chatOutlined.svg(color: COLORS.kDarkBlueColor),
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
                    style: TEXTSTYLES.kLinkSmall.copyWith(color: COLORS.kTextBlueColor),
                  ),
                ),
                CustomSizes.smallSizedBoxHeight,
                ...controller.calls.map(
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
        ),
      ),
    );
  }
}
