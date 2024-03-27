import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/models/add_contacts_view_arguments_model.dart';

import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:heyo/modules/core-ui/widgets/custom_dialog_widget.dart';
import 'package:heyo/modules/features/call_history/presentation/controllers/call_history_detail_controller.dart';
import 'package:heyo/modules/features/call_history/presentation/models/call_history_participant_view_model/call_history_participant_view_model.dart';

class CallHistoryAppBarBottomSheetWidget extends ConsumerStatefulWidget {
  const CallHistoryAppBarBottomSheetWidget({
    required this.callHistoryParticipant,
    super.key,
  });

  final CallHistoryParticipantViewModel callHistoryParticipant;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return CallHistoryAppBarBottomSheetWidgetState();
  }
}

class CallHistoryAppBarBottomSheetWidgetState
    extends ConsumerState<CallHistoryAppBarBottomSheetWidget> {
  bool isContact = false;

  @override
  void initState() {
    checkContactAvailability();
    super.initState();
  }

  Future<void> checkContactAvailability() async {
    final checkContact = await ref
        .read(callHistoryDetailNotifierProvider.notifier)
        .contactAvailability(
          widget.callHistoryParticipant.coreId,
        );
    setState(() {
      isContact = checkContact;
    });
  }

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
  Widget build(BuildContext context) {
    final controller = ref.read(callHistoryDetailNotifierProvider.notifier);

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
              Get
                ..back<void>()
                //* Push to Add contact page
                ..toNamed<void>(
                  Routes.ADD_CONTACTS,
                  arguments: AddContactsViewArgumentsModel(
                    coreId: widget.callHistoryParticipant.coreId,
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
                await showCustomDialog(
                  context,
                  indicatorIcon: Assets.svg.removeContact.svg(
                    color: COLORS.kDarkBlueColor,
                  ),
                  title: '${LocaleKeys.newChat_userBottomSheet_remove.tr} '
                      '${widget.callHistoryParticipant.name} '
                      '${LocaleKeys.newChat_userBottomSheet_fromContactsList.tr}',
                  confirmTitle: LocaleKeys.newChat_userBottomSheet_remove.tr,
                  onConfirm: () async {
                    await controller.deleteContactById(
                      widget.callHistoryParticipant.coreId,
                    );
                    //* Close Dialog
                    Get.back<void>();
                  },
                );
                //* Close BottomSheet
                Get.back<void>();
              },
            ),
          CustomSizes.mediumSizedBoxHeight,
        ],
      ),
    );
  }
}
