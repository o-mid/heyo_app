import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/call_history_detail/controllers/call_history_detail_controller.dart';
import 'package:heyo/app/modules/calls/call_history_detail/widgets/call_history_single_participant.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/widgets/appbar_widget.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class CallHistoryDetailView extends GetView<CallHistoryDetailController> {
  const CallHistoryDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        backgroundColor: COLORS.kGreenMainColor,
        title: LocaleKeys.CallHistory_appbar.tr,
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
      body: Obx(() {
        // if(controller.)
        return const CallHistorySingleParticipantView();
      }),
    );
  }
}
