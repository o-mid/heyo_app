import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_history_participant_model/call_history_participant_model.dart';
import 'package:heyo/modules/features/call_history/domain/call_history_repo.dart';
import 'package:heyo/app/modules/calls/usecase/contact_name_use_case.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/modules/features/call_history/utils/call_history_utils.dart';
import 'package:heyo/modules/features/call_history/presentation/models/call_history_participant_view_model/call_history_participant_view_model.dart';
import 'package:heyo/modules/features/call_history/presentation/models/call_history_view_model/call_history_view_model.dart';
import 'package:heyo/modules/features/call_history/presentation/widgets/call_history_list_tile_widget.dart';

final callHistoryNotifierProvider =
    AsyncNotifierProvider<CallHistoryController, List<CallHistoryViewModel>>(
  () => CallHistoryController(
    callHistoryRepo: inject.get<CallHistoryRepo>(),
    contactNameUseCase: inject.get<ContactNameUseCase>(),
    contactRepository: inject.get<ContactRepository>(),
  ),
);

class CallHistoryController extends AsyncNotifier<List<CallHistoryViewModel>> {
  CallHistoryController({
    required this.callHistoryRepo,
    required this.contactNameUseCase,
    required this.contactRepository,
  });

  final CallHistoryRepo callHistoryRepo;
  final ContactNameUseCase contactNameUseCase;
  final ContactRepository contactRepository;

  @override
  FutureOr<List<CallHistoryViewModel>> build() {
    unawaited(_listenToContactsToUpdateName());
    unawaited(_listenToCallRepository());

    return getData();
  }

  Future<List<CallHistoryViewModel>> getData() async {
    final callHistoryModel = await callHistoryRepo.getAllCalls();
    final calls = <CallHistoryViewModel>[];

    for (var i = 0; i < callHistoryModel.length; i++) {
      if (!calls.any((call) => call.callId == callHistoryModel[i].callId)) {
        final participantViewList = <CallHistoryParticipantViewModel>[];

        //* Loop on participants data model to get their name from contact
        //* And convert them to participants view model
        for (final participant in callHistoryModel[i].participants) {
          final name = await contactNameUseCase.execute(participant.coreId);
          participantViewList.add(
            participant.mapToCallHistoryParticipantViewModel(name),
          );
        }

        final callViewModel = CallHistoryViewModel(
          callId: callHistoryModel[i].callId,
          type: CallHistoryUtils.callTitle(callHistoryModel[i].status),
          status: CallHistoryUtils.callStatus(callHistoryModel[i]),
          participants: participantViewList,
          startDate: callHistoryModel[i].startDate,
          endDate: callHistoryModel[i].endDate,
        );
        calls.insert(i, callViewModel);
      }
    }

    return calls;
  }

  Future<void> _listenToCallRepository() async {
    final calls = state.value ?? [];

    (await callHistoryRepo.getCallsStream()).listen((newCalls) async {
      // remove the deleted calls
      for (var i = 0; i < calls.length; i++) {
        if (!newCalls.any((call) => call.callId == calls[i].callId)) {
          calls.removeAt(i);
        }
      }

      // add new calls
      for (var i = 0; i < newCalls.length; i++) {
        if (!calls.any((call) => call.callId == newCalls[i].callId)) {
          final participantViewList = <CallHistoryParticipantViewModel>[];

          //* Loop on participants data model to get their name from contact
          //* And convert them to participants view model
          for (final participant in newCalls[i].participants) {
            final name = await contactNameUseCase.execute(participant.coreId);
            participantViewList.add(
              participant.mapToCallHistoryParticipantViewModel(name),
            );
          }

          final callViewModel = CallHistoryViewModel(
            callId: newCalls[i].callId,
            type: CallHistoryUtils.callTitle(newCalls[i].status),
            status: CallHistoryUtils.callStatus(newCalls[i]),
            participants: participantViewList,
            startDate: newCalls[i].startDate,
            endDate: newCalls[i].endDate,
          );
          calls.insert(i, callViewModel);
        }
      }

      // update calls to latest changes
      for (var i = 0; i < newCalls.length; i++) {
        final participantViewList = <CallHistoryParticipantViewModel>[];

        //* Loop on participants data model to get their name from contact
        //* And convert them to participants view model
        for (final participant in newCalls[i].participants) {
          final name = await contactNameUseCase.execute(participant.coreId);
          participantViewList.add(
            participant.mapToCallHistoryParticipantViewModel(name),
          );
        }

        final callViewModel = CallHistoryViewModel(
          callId: newCalls[i].callId,
          type: CallHistoryUtils.callTitle(newCalls[i].status),
          status: CallHistoryUtils.callStatus(newCalls[i]),
          participants: participantViewList,
          startDate: newCalls[i].startDate,
          endDate: newCalls[i].endDate,
        );
        calls[i] = callViewModel;
      }
      state = AsyncData(calls);
    });
  }

  Future<void> _listenToContactsToUpdateName() async {
    (await contactRepository.getContactsStream()).listen((newContacts) async {
      final newCalls = <CallHistoryViewModel>[];
      if (state.value == null) {
        return;
      }
      for (final call in state.value!) {
        final participantViewList = <CallHistoryParticipantViewModel>[];

        for (final participant in call.participants) {
          // Check if there is a matching contact for the participant
          final matchingContact = newContacts.firstWhereOrNull(
            (contact) => participant.coreId == contact.coreId,
          );

          // Add the participant with updated name (if matched contact), or original participant
          participantViewList.add(
            matchingContact != null
                ? participant.copyWith(name: matchingContact.name)
                : participant.copyWith(name: participant.coreId.shortenCoreId),
          );
        }

        newCalls.add(call.copyWith(participants: participantViewList));
      }
      state = AsyncData(newCalls);
    });
  }

  Future<void> deleteCall(CallHistoryViewModel call) async {
    await callHistoryRepo.deleteOneCall(call.callId);
  }

  Future<void> deleteAllCalls() async {
    await callHistoryRepo.deleteAllCalls();
  }

  //void showDeleteAllCallsBottomSheet() {
  //  openDeleteAllCallHistoryBottomSheet(
  //    onDelete: () async {

  //      state = const AsyncData([]);
  //    },
  //  );
  //}
}
