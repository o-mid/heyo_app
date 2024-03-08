import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/shared/data/models/all_participant_model/all_participant_model.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_history_model/call_history_model.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_history_participant_model/call_history_participant_model.dart';
import 'package:heyo/app/modules/calls/shared/data/providers/call_history/call_history_provider.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_abstract_repo.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_repo.dart';
import 'package:heyo/app/modules/calls/usecase/contact_name_use_case.dart';
import 'package:heyo/app/modules/contacts/widgets/removeContactsDialog.dart';
import 'package:heyo/app/modules/shared/data/models/add_contacts_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/user_call_history_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/snackbar_widget.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:heyo/modules/call/presentation/call_history/call_history_participant_view_model/call_history_participant_view_model.dart';
import 'package:heyo/modules/call/presentation/call_history/call_history_view_model/call_history_view_model.dart';
import 'package:heyo/modules/call/presentation/call_history/call_utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final callHistoryDetailNotifierProvider = AutoDisposeAsyncNotifierProvider<
    CallHistoryDetailController, CallHistoryViewModel?>(
  () => CallHistoryDetailController(
    callHistoryRepo: CallHistoryRepo(
      callHistoryProvider: CallHistoryProvider(
        appDatabaseProvider: Get.find<AppDatabaseProvider>(),
      ),
    ),
    contactNameUseCase: ContactNameUseCase(
      contactRepository: Get.find(),
    ),
    contactRepository: Get.find(),
  ),
);

class CallHistoryDetailController
    extends AutoDisposeAsyncNotifier<CallHistoryViewModel?> {
  CallHistoryDetailController({
    required this.callHistoryRepo,
    required this.contactNameUseCase,
    required this.contactRepository,
  });

  final CallHistoryAbstractRepo callHistoryRepo;
  final ContactNameUseCase contactNameUseCase;
  final ContactRepository contactRepository;

  late UserCallHistoryViewArgumentsModel args;
  List<CallHistoryViewModel> recentCalls = [];

  //RxBool loading = true.obs;
  //late StreamSubscription<List<UserModel>> _contactsStreamSubscription;

  //RxList<CallHistoryDetailParticipantModel> participants = RxList();

  @override
  FutureOr<CallHistoryViewModel?> build() {
    args = Get.arguments as UserCallHistoryViewArgumentsModel;
    unawaited(_listenToContactsToUpdateName());
    unawaited(_listenToCallRepository());
    return getData();
  }

  FutureOr<CallHistoryViewModel?> getData() async {
    CallHistoryViewModel? callHistoryViewModel;
    try {
      recentCalls = [];
      final callHistoryDataModel =
          await callHistoryRepo.getOneCall(args.callId);

      if (callHistoryDataModel == null) {
        return null;
      }

      callHistoryViewModel =
          await convertToCallHistoryViewModel(callHistoryDataModel);
    } catch (e) {
      debugPrint(e.toString());
    }

    //* If the length is equal to one it means the call is p2p
    //* and app should show the user call history
    if (args.participants.length == 1) {
      recentCalls = [];
      final calls =
          await callHistoryRepo.getCallsFromUserId(args.participants[0]);

      for (final call in calls) {
        recentCalls.add(
          CallHistoryViewModel(
            callId: call.callId,
            type: CallUtils.callStatus(call),
            status: CallUtils.callTitle(call.status),
            participants: [],
            startDate: call.startDate,
            endDate: call.endDate,
          ),
        );
      }
    }

    state = AsyncData(callHistoryViewModel);
    return callHistoryViewModel;
  }

  Future<void> _listenToContactsToUpdateName() async {
    (await contactRepository.getContactsStream()).listen((newUsers) {
      if (state.isLoading) {
        return;
      }
      //* Fill the below list for updating call history participant
      final callHistoryNewParticipant = <CallHistoryParticipantViewModel>[];

      for (var i = 0; i < state.value!.participants.length; i++) {
        //* Add all the participant to list
        callHistoryNewParticipant.add(state.value!.participants[i]);
        for (var j = 0; j < newUsers.length; j++) {
          if (state.value!.participants[i].coreId == newUsers[j].coreId) {
            //* updated contact found in list
            // update participant with new contact name
            callHistoryNewParticipant[i] =
                state.value!.participants[i].copyWith(name: newUsers[j].name);
          }
        }
      }
      state = AsyncData(
        state.value!.copyWith(participants: callHistoryNewParticipant),
      );
    });
  }

  Future<void> _listenToCallRepository() async {
    (await callHistoryRepo.getCallsStream()).listen((newCalls) async {
      if (state.isLoading) {
        return;
      }
      getData();
    });
  }

  Future<CallHistoryViewModel> convertToCallHistoryViewModel(
    CallHistoryModel callHistoryDataModel,
  ) async {
    final participantViewList = <CallHistoryParticipantViewModel>[];

    //* Loop on participants data model to get their name from contact
    //* And convert them to participants view model
    for (final participant in callHistoryDataModel.participants) {
      final name = await contactNameUseCase.execute(participant.coreId);
      participantViewList.add(
        participant.mapToCallHistoryParticipantViewModel(name),
      );
    }

    //* Convert the call history data model to view model
    return CallHistoryViewModel(
      callId: callHistoryDataModel.callId,
      type: CallUtils.callStatus(callHistoryDataModel),
      status: CallUtils.callTitle(callHistoryDataModel.status),
      participants: participantViewList,
      startDate: callHistoryDataModel.startDate,
      endDate: callHistoryDataModel.endDate,
    );
  }

  Future<void> saveCoreIdToClipboard() async {
    final remoteCoreId = args.participants[0];
    debugPrint('Core ID : $remoteCoreId');
    await Clipboard.setData(ClipboardData(text: remoteCoreId));
    SnackBarWidget.info(
      message: LocaleKeys.ShareableQrPage_copiedToClipboardText.tr,
    );
  }

  Future<bool> contactAvailability(String coreId) async {
    final contact = await contactRepository.getContactById(coreId);
    if (contact == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> openAppBarActionBottomSheet({
    required CallHistoryParticipantViewModel participant,
  }) async {
    final isContact = await contactAvailability(participant.coreId);

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

    await Get.bottomSheet<void>(
      Padding(
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
                    await contactRepository
                        .deleteContactById(participant.coreId);
                    Get.back();
                  }
                },
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

  bool isGroupCall() => state.value!.participants.length > 1;

  void appBarAction() {
    if (isGroupCall()) {
      debugPrint('Nothing yet');
    } else {
      openAppBarActionBottomSheet(
        participant: state.value!.participants[0],
      );
    }
  }
}
