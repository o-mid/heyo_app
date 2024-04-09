import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_history_model/call_history_model.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_history_participant_model/call_history_participant_model.dart';
import 'package:heyo/app/modules/shared/data/models/user_call_history_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/modules/features/call_history/domain/call_history_repo.dart';
import 'package:heyo/modules/features/call_history/presentation/models/call_history_participant_view_model/call_history_participant_view_model.dart';
import 'package:heyo/modules/features/call_history/presentation/models/call_history_view_model/call_history_view_model.dart';
import 'package:heyo/modules/features/call_history/utils/call_history_utils.dart';
import 'package:heyo/modules/features/contact/domain/contact_repo.dart';
import 'package:heyo/modules/features/contact/usecase/contact_listener_use_case.dart';
import 'package:heyo/modules/features/contact/usecase/delete_contacts_use_case.dart';
import 'package:heyo/modules/features/contact/usecase/get_contact_by_id_use_case.dart';

final callHistoryDetailNotifierProvider = AutoDisposeAsyncNotifierProvider<
    CallHistoryDetailController, CallHistoryViewModel?>(
  () => CallHistoryDetailController(
    callHistoryRepo: inject.get<CallHistoryRepo>(),
    getContactByIdUseCase: GetContactByIdUseCase(
      contactRepository: inject.get<ContactRepo>(),
    ),
    contactListenerUseCase: ContactListenerUseCase(
      contactRepository: inject.get<ContactRepo>(),
    ),
    deleteContactsUseCase: DeleteContactsUseCase(
      contactRepository: inject.get<ContactRepo>(),
    ),
  ),
);

final callHistoryDetailRecentCallProvider = AutoDisposeAsyncNotifierProvider<
    CallHistoryDetailRecentCallController, List<CallHistoryViewModel>>(
  () => CallHistoryDetailRecentCallController(
    callHistoryRepo: inject.get<CallHistoryRepo>(),
  ),
);

class CallHistoryDetailController
    extends AutoDisposeAsyncNotifier<CallHistoryViewModel?> {
  CallHistoryDetailController({
    required this.callHistoryRepo,
    required this.getContactByIdUseCase,
    required this.contactListenerUseCase,
    required this.deleteContactsUseCase,
  });

  final CallHistoryRepo callHistoryRepo;
  final GetContactByIdUseCase getContactByIdUseCase;
  final DeleteContactsUseCase deleteContactsUseCase;
  final ContactListenerUseCase contactListenerUseCase;

  late UserCallHistoryViewArgumentsModel args;

  @override
  FutureOr<CallHistoryViewModel?> build() {
    args = Get.arguments as UserCallHistoryViewArgumentsModel;
    unawaited(_listenToContactsToUpdateName());
    return getData();
  }

  FutureOr<CallHistoryViewModel?> getData() async {
    CallHistoryViewModel? callHistoryViewModel;
    try {
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

    return callHistoryViewModel;
  }

  Future<void> _listenToContactsToUpdateName() async {
    (await contactListenerUseCase.execute()).listen((newUsers) {
      if (state.isLoading) {
        return;
      }
      //* Fill the below list for updating call history participant
      final callHistoryNewParticipant = <CallHistoryParticipantViewModel>[];

      if (newUsers.isNotEmpty) {
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
      } else {
        //* It's mean the contact deleted from call history detail
        // the name of user should change to it coreId
        callHistoryNewParticipant.add(
          state.value!.participants[0].copyWith(
            name: state.value!.participants[0].coreId.shortenCoreId,
          ),
        );
      }
      state = AsyncData(
        state.value!.copyWith(participants: callHistoryNewParticipant),
      );
    });
  }

  Future<CallHistoryViewModel> convertToCallHistoryViewModel(
    CallHistoryModel callHistoryDataModel,
  ) async {
    final participantViewList = <CallHistoryParticipantViewModel>[];

    //* Loop on participants data model to get their name from contact
    //* And convert them to participants view model
    for (final participant in callHistoryDataModel.participants) {
      final contact = await getContactByIdUseCase.execute(participant.coreId);
      participantViewList.add(
        participant.mapToCallHistoryParticipantViewModel(
          contact != null ? contact.name : participant.coreId,
        ),
      );
    }

    //* Convert the call history data model to view model
    return CallHistoryViewModel(
      callId: callHistoryDataModel.callId,
      type: CallHistoryUtils.callStatus(callHistoryDataModel),
      status: CallHistoryUtils.callTitle(callHistoryDataModel.status),
      participants: participantViewList,
      startDate: callHistoryDataModel.startDate,
      endDate: callHistoryDataModel.endDate,
    );
  }

  // TODO(AliAzim): we can move this method to other provider
  Future<bool> contactAvailability(String coreId) async {
    final contact = await getContactByIdUseCase.execute(coreId);
    if (contact == null) {
      return false;
    } else {
      return true;
    }
  }

  bool isGroupCall() => state.value!.participants.length > 1;

  Future<void> deleteContactById(String coreId) async {
    await deleteContactsUseCase.execute(coreId);
  }
}

class CallHistoryDetailRecentCallController
    extends AutoDisposeAsyncNotifier<List<CallHistoryViewModel>> {
  CallHistoryDetailRecentCallController({
    required this.callHistoryRepo,
  });

  final CallHistoryRepo callHistoryRepo;

  late UserCallHistoryViewArgumentsModel args;

  //RxBool loading = true.obs;
  //late StreamSubscription<List<UserModel>> _contactsStreamSubscription;

  //RxList<CallHistoryDetailParticipantModel> participants = RxList();

  @override
  FutureOr<List<CallHistoryViewModel>> build() {
    args = Get.arguments as UserCallHistoryViewArgumentsModel;

    unawaited(_listenToCallRepository());
    return getData();
  }

  FutureOr<List<CallHistoryViewModel>> getData() async {
    var recentCalls = <CallHistoryViewModel>[];

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
            type: CallHistoryUtils.callStatus(call),
            status: CallHistoryUtils.callTitle(call.status),
            participants: [],
            startDate: call.startDate,
            endDate: call.endDate,
          ),
        );
      }
    }

    state = AsyncData(recentCalls);
    return recentCalls;
  }

  Future<void> _listenToCallRepository() async {
    (await callHistoryRepo.getCallsStream()).listen((newCalls) async {
      if (state.isLoading) {
        return;
      }
      getData();
    });
  }
}
