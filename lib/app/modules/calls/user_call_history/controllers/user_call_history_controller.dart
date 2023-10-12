import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/shared/data/models/call_history_model/call_history_model.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_user_model.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_abstract_repo.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
import 'package:heyo/app/modules/shared/data/models/user_call_history_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/generated/locales.g.dart';

class UserCallHistoryController extends GetxController {
  UserCallHistoryController({
    required this.callHistoryRepo,
    required this.contactRepository,
  });

  final CallHistoryAbstractRepo callHistoryRepo;
  final ContactRepository contactRepository;

  late UserCallHistoryViewArgumentsModel args;
  final calls = <CallHistoryModel>[].obs;
  Rx<CallUserModel> user = CallUserModel(
    coreId: (Get.arguments as UserCallHistoryViewArgumentsModel).coreId,
    iconUrl: (Get.arguments as UserCallHistoryViewArgumentsModel).iconUrl ??
        'https://avatars.githubusercontent.com/u/2345136?v=4',
    name: (Get.arguments as UserCallHistoryViewArgumentsModel)
        .coreId
        .shortenCoreId,
    walletAddress: (Get.arguments).coreId as String,
    isContact: false,
  ).obs;

  @override
  void onInit() async {
    super.onInit();
    args = Get.arguments as UserCallHistoryViewArgumentsModel;
    await _getUserContact();
    await callHistoryRepo
        .getCallsFromUserId(args.coreId)
        .then((value) => calls.value = value);
  }

  _getUserContact() async {
    // check if user is already in contact
    UserModel? createdUser =
        await contactRepository.getContactById(args.coreId);

    if (createdUser == null) {
      createdUser = UserModel(
        coreId: args.coreId,
        iconUrl: args.iconUrl ??
            'https://avatars.githubusercontent.com/u/2345136?v=4',
        name: args.coreId.shortenCoreId,
        isOnline: true,
        isContact: false,
        walletAddress: args.coreId,
      );
      // adds the new user to the repo and update the UserModel
      await contactRepository.addContact(createdUser);
      // convert userModel to callUserModel
      user.value = createdUser.toCallUserModel();
    } else {
      // convert userModel to callUserModel
      user.value = createdUser.toCallUserModel();
    }
    user.refresh();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  Future<void> saveCoreIdToClipboard() async {
    final remoteCoreId = args.coreId;
    print('Core ID : $remoteCoreId');
    await Clipboard.setData(ClipboardData(text: remoteCoreId));
    Get.rawSnackbar(
      messageText: Text(
        LocaleKeys.ShareableQrPage_copiedToClipboardText.tr,
        style: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kDarkBlueColor),
        textAlign: TextAlign.center,
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
      backgroundColor: COLORS.kWhiteColor,
      snackStyle: SnackStyle.FLOATING,
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: true,
      maxWidth: 250.w,
      margin: EdgeInsets.only(bottom: 60.h),
      boxShadows: [
        BoxShadow(
          color: const Color(0xFF466087).withOpacity(0.1),
          offset: const Offset(0, 3),
          blurRadius: 10,
        ),
      ],
      borderRadius: 8,
    );
  }

  // void _addMockData() {
  //   var index = 0;
  //   calls.addAll([
  //     CallModel(
  //       id: "${index++}",
  //       type: CallType.audio,
  //       status: CallStatus.incomingAnswered,
  //       date: DateTime.now().subtract(const Duration(minutes: 14)),
  //       duration: const Duration(seconds: 704),
  //       dataUsageMB: 542.6,
  //       user: args.user,
  //     ),
  //     CallModel(
  //       id: "${index++}",
  //       type: CallType.audio,
  //       status: CallStatus.outgoingCanceled,
  //       date: DateTime.now().subtract(const Duration(minutes: 37)),
  //       user: args.user,
  //     ),
  //     CallModel(
  //       id: "${index++}",
  //       type: CallType.video,
  //       status: CallStatus.incomingMissed,
  //       date: DateTime.utc(2022, DateTime.march, 30, 20, 32),
  //       user: args.user,
  //     ),
  //     CallModel(
  //       id: "${index++}",
  //       type: CallType.audio,
  //       status: CallStatus.outgoingDeclined,
  //       date: DateTime.utc(2022, DateTime.march, 30, 17, 44),
  //       user: args.user,
  //     ),
  //     CallModel(
  //       id: "${index++}",
  //       type: CallType.audio,
  //       status: CallStatus.outgoingNotAnswered,
  //       date: DateTime.utc(2022, DateTime.march, 29, 21, 17),
  //       user: args.user,
  //     ),
  //     CallModel(
  //       id: "${index++}",
  //       type: CallType.video,
  //       status: CallStatus.incomingMissed,
  //       date: DateTime.utc(2022, DateTime.march, 28, 20, 48),
  //       user: args.user,
  //     ),
  //     CallModel(
  //       id: "${index++}",
  //       type: CallType.audio,
  //       status: CallStatus.incomingAnswered,
  //       date: DateTime.utc(2022, DateTime.february, 16, 20, 59),
  //       duration: const Duration(seconds: 156),
  //       dataUsageMB: 55.6,
  //       user: args.user,
  //     ),
  //     CallModel(
  //       id: "${index++}",
  //       type: CallType.audio,
  //       status: CallStatus.incomingAnswered,
  //       date: DateTime.utc(2022, DateTime.february, 15, 9, 2),
  //       user: args.user,
  //     ),
  //   ]);
  // }
}
