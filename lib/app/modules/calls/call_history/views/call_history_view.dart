import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/call_history/controllers/call_history_controller.dart';
import 'package:heyo/app/modules/calls/call_history/widgets/call_history_list_tile_widget.dart';
import 'package:heyo/app/modules/calls/call_history/widgets/empty_call_history_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/widgets/appbar_widget.dart';
import 'package:heyo/app/modules/shared/widgets/connection_status.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class CallHistoryView extends GetView<CallHistoryController> {
  const CallHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLORS.kAppBackground,
      appBar: AppBarWidget(
        title: LocaleKeys.HomePage_navbarItems_calls.tr,
        actions: [
          Obx(() {
            if (controller.calls.isNotEmpty) {
              return IconButton(
                splashRadius: 18,
                onPressed: controller.showDeleteAllCallsBottomSheet,
                icon: Assets.svg.verticalMenuIcon.svg(),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConnectionStatusWidget(),
          Expanded(
            child: Obx(() {
              return controller.calls.isEmpty
                  ? const EmptyCallHistoryWidget()
                  : AnimatedList(
                      key: controller.animatedListKey,
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      initialItemCount: controller.calls.length,
                      itemBuilder: (context, index, animation) {
                        return CallHistoryListTitleWidget(
                          call: controller.calls[index],
                        );
                      },
                    );
            }),
          ),
        ],
      ),
    );
  }
}
