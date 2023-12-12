import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/app/modules/calls/shared/widgets/callee_or_caller_info_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/generated/locales.g.dart';

class CallRingingWidget extends StatelessWidget {
  const CallRingingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Get.find<CallController>().args.user;
    return Center(
      child: Column(
        children: [
          SizedBox(height: 105.h),
          CalleeOrCallerInfoWidget(
            coreId: user.coreId,
            name: user.name,
            isContact: user.isContact,
            shortenCoreId: user.coreId.shortenCoreId,
          ),
          SizedBox(height: 40.h),
          Text(
            LocaleKeys.CallPage_ringing.tr,
            style: TEXTSTYLES.kBodyBasic.copyWith(
              color: COLORS.kWhiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
