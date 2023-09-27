//import 'package:flutter/material.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:get/get.dart';
//import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
//import 'package:heyo/app/modules/calls/shared/widgets/callee_or_caller_info_widget.dart';
//import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
//import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
//import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
//import 'package:heyo/generated/assets.gen.dart';
//import 'package:heyo/generated/locales.g.dart';

//class CalleeOfflineWidget extends StatelessWidget {
//  const CalleeOfflineWidget({Key? key}) : super(key: key);

//  @override
//  Widget build(BuildContext context) {
//    //TODO Call
//    final user = Get.find<CallController>().getMockUser();
//    return Column(
//      children: [
//        SizedBox(height: 105.h),
//        CalleeOrCallerInfoWidget(
//          coreId: user.coreId,
//          iconUrl: user.iconUrl,
//          name: user.name,
//        ),
//        SizedBox(height: 40.h),
//        Row(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: [
//            Assets.svg.noConnectionWifi.svg(),
//            CustomSizes.smallSizedBoxWidth,
//            Text(
//              LocaleKeys.CallPage_currentlyOffline.tr,
//              style: TEXTSTYLES.kBodyBasic.copyWith(
//                color: COLORS.kWhiteColor,
//              ),
//            ),
//          ],
//        ),
//        const Spacer(),
//        TextButton(
//          onPressed: () {}, // Todo
//          style: TextButton.styleFrom(
//            backgroundColor: COLORS.kDarkBlueColor,
//            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 9.h),
//            shape: RoundedRectangleBorder(
//              borderRadius: BorderRadius.circular(8.r),
//            ),
//          ),
//          child: Text(
//            LocaleKeys.CallPage_sendAMessageButton.tr,
//            style: TEXTSTYLES.kLinkBig.copyWith(
//              color: COLORS.kWhiteColor,
//            ),
//          ),
//        ),
//        TextButton(
//          onPressed: Get.back,
//          style: TextButton.styleFrom(
//            padding: EdgeInsets.symmetric(
//              horizontal: 32.w,
//              vertical: 9.h,
//            ),
//            shape: RoundedRectangleBorder(
//              borderRadius: BorderRadius.circular(8.r),
//            ),
//          ),
//          child: Text(
//            LocaleKeys.CallPage_close.tr,
//            style: TEXTSTYLES.kLinkBig.copyWith(
//              color: COLORS.kTextSoftBlueColor,
//            ),
//          ),
//        ),
//        SizedBox(height: 20.h),
//      ],
//    );
//  }
//}
