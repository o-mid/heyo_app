import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/widgets/bottom_sheet.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:heyo/modules/features/chats/presentation/widgets/delete_all_chats_dialog.dart';

void openDeleteAllChatsBottomSheet({
  required BuildContext context,
  required VoidCallback onDelete,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: COLORS.kWhiteColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    builder: (BuildContext context) {
      return DeleteAllChatsBottomSheet(
        onDelete: onDelete,
      );
    },
  );
}

class DeleteAllChatsBottomSheet extends StatelessWidget {
  const DeleteAllChatsBottomSheet({Key? key, required this.onDelete}) : super(key: key);
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: HeyoBottomSheetContainer(
        children: [
          TextButton(
            onPressed: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return const DeleteAllChatsDialog();
                },
              );
              if (result != null && result) {
                onDelete();
              }

              Navigator.of(context).pop();
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
                  LocaleKeys.HomePage_Chats_bottomSheet_deleteAllchats.tr,
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
