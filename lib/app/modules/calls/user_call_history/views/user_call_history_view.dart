import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

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
        child: Column(
          children: [
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
