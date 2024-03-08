import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/widgets/bottom_sheet.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:heyo/modules/call/presentation/call_history/call_history_controller.dart';
import 'package:heyo/modules/core-ui/widgets/custom_dialog_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DeleteAllCallHistoryBottomSheet extends ConsumerWidget {
  const DeleteAllCallHistoryBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(callHistoryNotifierProvider.notifier);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: HeyoBottomSheetContainer(
        children: [
          ListTile(
            onTap: () async {
              await showCustomDialog(
                context,
                title: LocaleKeys.HomePage_Calls_deleteAllCallsDialog_title.tr,
                confirmTitle:
                    LocaleKeys.HomePage_Calls_deleteAllCallsDialog_delete.tr,
                indicatorIcon:
                    Assets.svg.deleteIcon.svg(color: COLORS.kDarkBlueColor),
                onConfirm: controller.deleteAllCalls,
              );
              //* pop the bottom sheet
              Get.back<void>();
            },
            leading: Container(
              padding: EdgeInsets.all(10.w),
              decoration: const BoxDecoration(
                color: COLORS.kBrightBlueColor,
                shape: BoxShape.circle,
              ),
              child: Assets.svg.deleteIcon.svg(
                color: COLORS.kDarkBlueColor,
              ),
            ),
            title: Text(
              LocaleKeys.HomePage_Calls_bottomSheet_deleteAllCalls.tr,
              style: TEXTSTYLES.kLinkBig.copyWith(
                color: COLORS.kDarkBlueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
