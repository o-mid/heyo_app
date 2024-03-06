import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_history_participant_model/call_history_participant_model.dart';
import 'package:heyo/app/modules/calls/shared/data/providers/call_history/call_history_provider.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_abstract_repo.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_repo.dart';
import 'package:heyo/app/modules/calls/usecase/contact_name_use_case.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/modules/call/presentation/call_history/call_history_participant_view_model/call_history_participant_view_model.dart';
import 'package:heyo/modules/call/presentation/call_history/call_history_view_model/call_history_view_model.dart';
import 'package:heyo/modules/call/presentation/call_history/call_utils.dart';
import 'package:heyo/modules/call/presentation/call_history/widgets/call_history_list_tile_widget.dart';
import 'package:heyo/modules/call/presentation/call_history/widgets/delete_all_calls_bottom_sheet.dart';
import 'package:heyo/modules/call/presentation/call_history/widgets/delete_call_history_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final callHistoryNotifierProvider = AutoDisposeAsyncNotifierProvider<
    CallHistoryController, List<CallHistoryViewModel>>(
  () => CallHistoryController(
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

class CallHistoryController
    extends AutoDisposeAsyncNotifier<List<CallHistoryViewModel>> {
  CallHistoryController({
    required this.callHistoryRepo,
    required this.contactNameUseCase,
    required this.contactRepository,
  });

  final CallHistoryAbstractRepo callHistoryRepo;
  final ContactNameUseCase contactNameUseCase;
  final ContactRepository contactRepository;

  //final calls = <CallHistoryViewModel>[].obs;
  final animatedListKey = GlobalKey<AnimatedListState>();

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
          type: CallUtils.callTitle(callHistoryModel[i].status),
          status: CallUtils.callStatus(callHistoryModel[i]),
          participants: participantViewList,
          startDate: callHistoryModel[i].startDate,
          endDate: callHistoryModel[i].endDate,
        );
        calls.insert(i, callViewModel);
        animatedListKey.currentState?.insertItem(i);
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
          _removeAtAnimatedList(i, calls[i]);
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
            type: CallUtils.callTitle(newCalls[i].status),
            status: CallUtils.callStatus(newCalls[i]),
            participants: participantViewList,
            startDate: newCalls[i].startDate,
            endDate: newCalls[i].endDate,
          );
          calls.insert(i, callViewModel);
          animatedListKey.currentState?.insertItem(i);
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
          type: CallUtils.callTitle(newCalls[i].status),
          status: CallUtils.callStatus(newCalls[i]),
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

  Future<bool> showDeleteCallDialog(CallHistoryViewModel call) async {
    await Get.dialog<bool>(
      DeleteCallHistoryDialog(deleteCall: () => deleteCall(call)),
    );
    return false;
  }

  void _removeAtAnimatedList(int index, CallHistoryViewModel call) {
    animatedListKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: CallHistoryListTitleWidget(call: call),
      ),
    );
  }

  void showDeleteAllCallsBottomSheet() {
    openDeleteAllCallHistoryBottomSheet(
      onDelete: () async {
        await callHistoryRepo.deleteAllCalls();
        state = const AsyncData([]);
      },
    );
  }
}
