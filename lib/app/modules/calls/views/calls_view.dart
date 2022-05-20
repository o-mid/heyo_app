import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/widgets/call_log_widget.dart';
import 'package:heyo/app/modules/calls/widgets/empty_calls_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

import '../controllers/calls_controller.dart';

class CallsView extends GetView<CallsController> {
  const CallsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: COLORS.kGreenMainColor,
        title: Text(
          LocaleKeys.HomePage_navbarItems_calls.tr,
          style: TEXTSTYLES.kHeaderLarge,
        ),
        automaticallyImplyLeading: false,
        actions: [
          if (controller.calls.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(right: 26.w),
              child: GestureDetector(
                onTap: () {},
                child: Assets.svg.verticalMenuIcon.svg(),
              ),
            ),
        ],
      ),
      body: controller.calls.isEmpty
          ? const EmptyCallsWidget()
          : ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
              itemCount: controller.calls.length,
              itemBuilder: (context, index) => CallLogWidget(call: controller.calls[index]),
              separatorBuilder: (context, index) => CustomSizes.mediumSizedBoxHeight,
            ),
    );
  }
}
