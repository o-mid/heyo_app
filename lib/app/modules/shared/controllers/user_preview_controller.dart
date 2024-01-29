import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_abstract_repo.dart';
import 'package:heyo/app/modules/chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/transitions_constant.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/widgets/user_preview_widget.dart';

class UserPreview extends GetxController {
  final ContactRepository contactRepository;
  final RxBool isWifiDirectConnection = false.obs;
  final CallHistoryAbstractRepo callHistoryRepo;
  final ChatHistoryLocalAbstractRepo chatHistoryRepo;

  UserPreview({
    required this.contactRepository,
    required this.callHistoryRepo,
    required this.chatHistoryRepo,
  });

  Future<void> openUserPreview({
    bool isWifiDirect = false,
    required String coreId,
    required String name,
    //required bool isVerified,
    //required bool isContact,
  }) async {
    isWifiDirectConnection.value = isWifiDirect;
    print("openUserPreviewBottomSheet");

    await Get.bottomSheet(
      enterBottomSheetDuration: TRANSITIONS.newChat_EnterBottomSheetDuration,
      exitBottomSheetDuration: TRANSITIONS.newChat_ExitBottomSheetDuration,
      UserPreviewWidget(
        coreId: coreId,
        name: name,
        //isVerified: isVerified,
        //isContact: isContact,
      ),
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

  Future<void> deleteContact(String userCoreId) async {
    await contactRepository
        .deleteContactById(userCoreId)
        .then((value) => print("object deleted  $value "));

    final chatModel = await chatHistoryRepo.getChat(userCoreId);
    if (chatModel != null) {
      await chatHistoryRepo
          .updateChat(chatModel.copyWith(name: userCoreId.shortenCoreId));
    }
    final calls = await callHistoryRepo.getCallsFromUserId(userCoreId);
    calls.forEach((call) async {
      //TODO:(Aliazim) update model why delete and create !?
      await callHistoryRepo.deleteOneCall(call.callId);
      await callHistoryRepo.addCallToHistory(
        call.copyWith(
          //TODO:(Aliazim) the call history participant will change
          participants: [call.participants[0]],
        ),
      );
    });
  }
}
