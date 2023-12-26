import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/call_history_detail/controllers/models/call_history_detail_participant_model.dart';

import 'package:heyo/app/modules/calls/shared/data/models/call_history_model/call_history_model.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_abstract_repo.dart';
import 'package:heyo/app/modules/calls/usecase/contact_availability_use_case.dart';
import 'package:heyo/app/modules/shared/data/models/add_contacts_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/user_call_history_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class CallHistoryDetailController extends GetxController {
  CallHistoryDetailController({
    required this.callHistoryRepo,
    required this.contactAvailabilityUseCase,
  });

  final CallHistoryAbstractRepo callHistoryRepo;
  final ContactAvailabilityUseCase contactAvailabilityUseCase;

  late UserCallHistoryViewArgumentsModel args;
  final calls = <CallHistoryModel>[].obs;

  RxList<CallHistoryDetailParticipantModel> participants = RxList();

  @override
  Future<void> onInit() async {
    super.onInit();
    args = Get.arguments as UserCallHistoryViewArgumentsModel;
    await getData();
  }

  Future<void> getData() async {
    for (final participant in args.participants) {
      final checkContactAvailability = await contactAvailabilityUseCase.execute(
        coreId: participant,
      );
      participants.add(
        checkContactAvailability.mapToHistoryParticipantModel(),
      );
    }

    //* If the length is equal to one it means the call is p2p
    //* and app should show the user call history
    if (args.participants.length == 1) {
      calls.value =
          await callHistoryRepo.getCallsFromUserId(args.participants[0]);
    }
  }

  Future<void> saveCoreIdToClipboard() async {
    final remoteCoreId = args.participants[0];
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

  Future<void> openAppBarActionBottomSheet({
    required CallHistoryDetailParticipantModel participant,
  }) async {
    await Get.bottomSheet(
      Padding(
        padding: CustomSizes.iconListPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                Get.back();

                final userModel = participant.mapToUserModel();

                Get.toNamed(
                  Routes.ADD_CONTACTS,
                  arguments: AddContactsViewArgumentsModel(
                    //  user: userModel,
                    coreId: userModel.coreId,
                    iconUrl: userModel.iconUrl,
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: COLORS.kBrightBlueColor,
                    ),
                    child: Assets.svg.addToContactsIcon.svg(
                      width: 20,
                      height: 20,
                    ),
                  ),
                  CustomSizes.mediumSizedBoxWidth,
                  Text(
                    LocaleKeys.newChat_userBottomSheet_addToContacts.tr,
                    style: TEXTSTYLES.kLinkBig.copyWith(
                      color: COLORS.kDarkBlueColor,
                    ),
                  ),
                ],
              ),
            ),
            CustomSizes.mediumSizedBoxHeight,
          ],
        ),
      ),
      backgroundColor: COLORS.kWhiteColor,
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
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
