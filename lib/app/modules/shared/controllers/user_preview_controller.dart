import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/transitions_constant.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/widgets/user_preview_widget.dart';
import 'package:heyo/modules/features/call_history/domain/call_history_repo.dart';
import 'package:heyo/modules/features/contact/usecase/delete_contacts_use_case.dart';
import 'package:heyo/modules/features/contact/usecase/get_contact_by_id_use_case.dart';

class UserPreviewController extends GetxController {
  UserPreviewController({
    required this.deleteContactsUseCase,
    required this.getContactByIdUseCase,
    required this.callHistoryRepo,
    required this.chatHistoryRepo,
  });

  final DeleteContactsUseCase deleteContactsUseCase;
  final GetContactByIdUseCase getContactByIdUseCase;
  final RxBool isWifiDirectConnection = false.obs;
  final CallHistoryRepo callHistoryRepo;
  final ChatHistoryLocalAbstractRepo chatHistoryRepo;
  RxBool isContact = false.obs;
  RxString name = ''.obs;

  Future<void> openUserPreview({
    bool isWifiDirect = false,
    required String coreId,
    //required String name,
    //required bool isVerified,
    //required bool isContact,
  }) async {
    await contactAvailability(coreId);

    isWifiDirectConnection.value = isWifiDirect;
    print("openUserPreviewBottomSheet");

    await Get.bottomSheet(
      UserPreviewWidget(coreId: coreId),
      enterBottomSheetDuration: TRANSITIONS.newChat_EnterBottomSheetDuration,
      exitBottomSheetDuration: TRANSITIONS.newChat_ExitBottomSheetDuration,
      backgroundColor: COLORS.kWhiteColor,
      isDismissible: true,
      isScrollControlled: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  Future<void> contactAvailability(String coreId) async {
    final contact = await getContactByIdUseCase.execute(coreId);
    if (contact == null) {
      isContact.value = false;
      name.value = coreId.shortenCoreId;
    } else {
      name.value = contact.name;
      isContact.value = true;
    }
  }

  Future<void> deleteContact(String userCoreId) async {
    await deleteContactsUseCase.execute(userCoreId);

    final chatModel = await chatHistoryRepo.getChat(userCoreId);
    if (chatModel != null) {
      await chatHistoryRepo
          .updateChat(chatModel.copyWith(name: userCoreId.shortenCoreId));
    }
  }
}
