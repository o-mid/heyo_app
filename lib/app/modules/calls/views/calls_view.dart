import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/widgets/call_log_widget.dart';
import 'package:heyo/app/modules/calls/widgets/empty_calls_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

import '../controllers/calls_controller.dart';

class CallsView extends GetView<CallsController> {
  const CallsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLORS.kAppBackground,
      appBar: AppBar(
        backgroundColor: COLORS.kGreenMainColor,
        title: Text(
          LocaleKeys.HomePage_navbarItems_calls.tr,
          style: TEXTSTYLES.kHeaderLarge,
        ),
        automaticallyImplyLeading: false,
        actions: [
          Obx(() {
            if (controller.calls.isNotEmpty) {
              return Padding(
                padding: EdgeInsets.only(right: 26.w),
                child: GestureDetector(
                  onTap: controller.showDeleteAllCallsBottomSheet,
                  child: Assets.svg.verticalMenuIcon.svg(),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        return controller.calls.isEmpty
            ? const EmptyCallsWidget()
            : AnimatedList(
                key: controller.animatedListKey,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                initialItemCount: controller.calls.length,
                itemBuilder: (context, index, animation) =>
                    CallLogWidget(call: controller.calls[index]),
              );
      }),
    );
  }
}
