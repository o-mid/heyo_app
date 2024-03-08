import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:heyo/modules/call/presentation/call_history/call_history_participant_view_model/call_history_participant_view_model.dart';
import 'package:heyo/modules/call/presentation/call_history_detail/call_history_detail_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CallHistoryAppBarBottomSheetWidget extends ConsumerWidget {
  const CallHistoryAppBarBottomSheetWidget({
    required this.callHistoryParticipant,
    super.key,
  });

  final CallHistoryParticipantViewModel callHistoryParticipant;

  Widget bottomSheetItem({
    required String title,
    required Widget icon,
    void Function()? onTap,
  }) {
    return TextButton(
      onPressed: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: COLORS.kBrightBlueColor,
            ),
            child: icon,
          ),
          CustomSizes.mediumSizedBoxWidth,
          Text(
            title,
            style: TEXTSTYLES.kLinkBig.copyWith(
              color: COLORS.kDarkBlueColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isContact =
      await  ref.read(callHistoryDetailNotifierProvider.notifier).isContact(
              callHistoryParticipant.coreId,
            );
    return Padding(
      padding: CustomSizes.iconListPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          bottomSheetItem(
            title: isContact
                ? LocaleKeys.newChat_userBottomSheet_contactInfo.tr
                : LocaleKeys.newChat_userBottomSheet_addToContacts.tr,
            icon: Assets.svg.addToContactsIcon.svg(
              color: COLORS.kDarkBlueColor,
              width: 20,
              height: 20,
            ),
            onTap: () {
              //* Close bottom sheet
              Get.back();
              final userModel = participant.mapToUserModel();
              Get.toNamed(
                Routes.ADD_CONTACTS,
                arguments: AddContactsViewArgumentsModel(
                  //  user: userModel,
                  coreId: userModel.coreId,
                ),
              );
            },
          ),
          if (isContact)
            bottomSheetItem(
              title: LocaleKeys.newChat_userBottomSheet_RemoveFromContacts.tr,
              icon: Assets.svg.deleteIcon.svg(
                color: COLORS.kDarkBlueColor,
                width: 20,
                height: 20,
              ),
              onTap: () async {
                final result = await Get.dialog(
                  RemoveContactsDialog(
                    userName: participant.name,
                  ),
                );

                if (result is bool && result == true) {
                  print("result   $result");
                  await contactRepository.deleteContactById(participant.coreId);
                  Get.back();
                }
              },
            ),
          CustomSizes.mediumSizedBoxHeight,
        ],
      ),
    );
  }
}
