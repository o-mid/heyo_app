import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/widgets/delete_all_calls_dialog.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/widgets/bottom_sheet.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

void openDeleteAllCallsBottomSheet({required VoidCallback onDelete}) {
  Get.bottomSheet(
    backgroundColor: COLORS.kWhiteColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    DeleteAllCallsBottomSheet(onDelete: onDelete),
  );
}

class DeleteAllCallsBottomSheet extends StatelessWidget {
  final VoidCallback onDelete;
  const DeleteAllCallsBottomSheet({Key? key, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: HeyoBottomSheetContainer(
        children: [
          TextButton(
            onPressed: () async {
              final result = await Get.dialog(const DeleteAllCallsDialog());
              if (result) {
                onDelete();
              }
              Get.back();
            },
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  padding: EdgeInsets.all(10.w),
                  decoration: const BoxDecoration(
                    color: COLORS.kBrightBlueColor,
                    shape: BoxShape.circle,
                  ),
                  child: Assets.svg.deleteIcon.svg(color: COLORS.kDarkBlueColor),
                ),
                SizedBox(width: 20.w),
                Text(
                  LocaleKeys.HomePage_Calls_bottomSheet_deleteAllCalls.tr,
                  style: TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kDarkBlueColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
