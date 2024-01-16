import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_model.dart';
import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/messages_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/widgets/circle_icon_button.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

import '../../../routes/app_pages.dart';
import '../../contacts/widgets/removeContactsDialog.dart';
import '../../shared/data/models/add_contacts_view_arguments_model.dart';
import '../../shared/data/repository/contact_repository.dart';
import '../../shared/utils/constants/textStyles.dart';
import '../../shared/utils/constants/transitions_constant.dart';
import '../../shared/utils/screen-utils/sizing/custom_sizes.dart';
import '../../shared/widgets/curtom_circle_avatar.dart';
import '../widgets/user_preview_widget.dart';
import '../../calls/shared/data/repos/call_history/call_history_abstract_repo.dart';

class UserPreview extends GetxController {
  final ContactRepository contactRepository;
  final RxBool isWifiDirectConnection = false.obs;
  final CallHistoryAbstractRepo callHistoryRepo;
  final ChatHistoryLocalAbstractRepo chatHistoryRepo;

  UserPreview(
      {required this.contactRepository,
      required this.callHistoryRepo,
      required this.chatHistoryRepo});

  Future<void> openUserPreview({
    bool isWifiDirect = false,
    required UserModel userModel,
  }) async {
    isWifiDirectConnection.value = isWifiDirect;
    print("openUserPreviewBottomSheet");

    await Get.bottomSheet(
      enterBottomSheetDuration: TRANSITIONS.newChat_EnterBottomSheetDuration,
      exitBottomSheetDuration: TRANSITIONS.newChat_ExitBottomSheetDuration,
      UserPreviewWidget(user: userModel),
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
        .deleteContactById(
          userCoreId,
        )
        .then((value) => print("object deleted  $value "));

    ChatModel? chatModel = await chatHistoryRepo.getChat(userCoreId);
    if (chatModel != null) {
      await chatHistoryRepo
          .updateChat(chatModel.copyWith(name: userCoreId.shortenCoreId));
    }
    List<CallModel> calls =
        await callHistoryRepo.getCallsFromUserId(userCoreId);
    calls.forEach((call) async {
      await callHistoryRepo.deleteOneCall(call.id);
      await callHistoryRepo.addCallToHistory(call.copyWith(
          user: call.user
              .copyWith(name: userCoreId.shortenCoreId, isContact: false)));
    });
  }
}
