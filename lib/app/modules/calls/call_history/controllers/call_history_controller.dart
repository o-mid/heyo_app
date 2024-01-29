import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/call_history/views/models/call_history_participant_view_model/call_history_participant_view_model.dart';
import 'package:heyo/app/modules/calls/call_history/views/models/call_history_view_model/call_history_view_model.dart';

import 'package:heyo/app/modules/calls/call_history/widgets/call_history_list_tile_widget.dart';
import 'package:heyo/app/modules/calls/call_history/widgets/delete_all_calls_bottom_sheet.dart';
import 'package:heyo/app/modules/calls/call_history/widgets/delete_call_history_dialog.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_history_model/call_history_model.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_history_participant_model/call_history_participant_model.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_abstract_repo.dart';
import 'package:heyo/app/modules/calls/shared/utils/call_utils.dart';
import 'package:heyo/app/modules/calls/usecase/contact_name_use_case.dart';

class CallHistoryController extends GetxController {
  CallHistoryController({
    required this.callHistoryRepo,
    required this.contactNameUseCase,
  });

  final CallHistoryAbstractRepo callHistoryRepo;
  final ContactNameUseCase contactNameUseCase;

  final calls = <CallHistoryViewModel>[].obs;
  final animatedListKey = GlobalKey<AnimatedListState>();

  late StreamSubscription<List<CallHistoryModel>> _callsStreamSubscription;

  RxBool loading = true.obs;

  @override
  void onInit() {
    super.onInit();

    // _addMockData();
    init();
  }

  //@override
  //void onReady() {
  //  super.onReady();
  //}

  @override
  void onClose() {
    _callsStreamSubscription.cancel();
    super.onClose();
  }

  Future<void> init() async {
    //calls.value = await callHistoryRepo.getAllCalls();

    _callsStreamSubscription =
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
    });
    loading.value = false;
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

  //void _addMockData() {
  //  final uBoiled = UserModel(
  //    name: 'Boiled Dealmaker',
  //    iconUrl: 'https://avatars.githubusercontent.com/u/6645136?v=4',
  //    isVerified: true,
  //    walletAddress: 'CB11${List.generate(11, (index) => index).join()}14AB',
  //    coreId: 'CB11${List.generate(11, (index) => index).join()}14AB',
  //  );
  //  final uCrapps = UserModel(
  //    name: 'Crapps Wallbanger',
  //    iconUrl: 'https://avatars.githubusercontent.com/u/2345136?v=4',
  //    walletAddress: 'CB11${List.generate(11, (index) => index).join()}49BB',
  //    coreId: 'CB11${List.generate(11, (index) => index).join()}49BB',
  //  );
  //  final uFancy = UserModel(
  //    name: 'Fancy Potato',
  //    iconUrl: 'https://avatars.githubusercontent.com/u/6644146?v=4',
  //    walletAddress: 'CB11${List.generate(11, (index) => index).join()}11FE',
  //    coreId: 'CB11${List.generate(11, (index) => index).join()}11FE',
  //  );
  //  final uOckerito = UserModel(
  //    name: 'Ockerito Fazola',
  //    isVerified: true,
  //    iconUrl: 'https://avatars.githubusercontent.com/u/7844146?v=4',
  //    walletAddress: 'CB11${List.generate(11, (index) => index).join()}5A5D',
  //    coreId: 'CB11${List.generate(11, (index) => index).join()}5A5D',
  //  );
  //  final uUnchained = UserModel(
  //    name: 'Unchained Banana',
  //    iconUrl: 'https://avatars.githubusercontent.com/u/7847725?v=4',
  //    walletAddress: 'CB11${List.generate(11, (index) => index).join()}44AC',
  //    coreId: 'CB11${List.generate(11, (index) => index).join()}44AC',
  //  );
  //  final uSwagger = UserModel(
  //    name: 'Swagger Uncut',
  //    iconUrl: 'https://avatars.githubusercontent.com/u/9947725?v=4',
  //    walletAddress: 'CB11${List.generate(11, (index) => index).join()}532A',
  //    coreId: 'CB11${List.generate(11, (index) => index).join()}532A',
  //  );
  //  var index = 0;
  //  final calls = [
  //    CallHistoryModel(
  //      callId: '${index++}',
  //      type: CallType.audio,
  //      status: CallStatus.outgoingCanceled,
  //      startDate: DateTime.now().subtract(const Duration(minutes: 37)),
  //      participants: [uBoiled],
  //      coreId: uBoiled.coreId,
  //    ),
  //    CallHistoryModel(
  //      callId: '${index++}',
  //      type: CallType.video,
  //      status: CallStatus.incomingMissed,
  //      startDate: DateTime.utc(2022, DateTime.march, 30, 20, 32),
  //      participants: [uCrapps],
  //      coreId: uCrapps.coreId,
  //    ),
  //    CallHistoryModel(
  //      callId: '${index++}',
  //      type: CallType.audio,
  //      status: CallStatus.outgoingNotAnswered,
  //      startDate: DateTime.utc(2022, DateTime.march, 30, 17, 44),
  //      participants: [uFancy],
  //      coreId: uFancy.coreId,
  //    ),
  //    CallHistoryModel(
  //      callId: '${index++}',
  //      type: CallType.audio,
  //      status: CallStatus.outgoingNotAnswered,
  //      startDate: DateTime.utc(2022, DateTime.march, 29, 21, 17),
  //      participants: [uOckerito],
  //      coreId: uOckerito.coreId,
  //    ),
  //    CallHistoryModel(
  //      callId: '${index++}',
  //      type: CallType.video,
  //      status: CallStatus.incomingMissed,
  //      startDate: DateTime.utc(2022, DateTime.march, 28, 20, 48),
  //      participants: [uUnchained],
  //      coreId: uUnchained.coreId,
  //    ),
  //    CallHistoryModel(
  //      callId: '${index++}',
  //      type: CallType.audio,
  //      status: CallStatus.incomingAnswered,
  //      startDate: DateTime.utc(2022, DateTime.february, 16, 20, 59),
  //      participants: [uUnchained],
  //      coreId: uUnchained.coreId,
  //    ),
  //    CallHistoryModel(
  //      callId: '${index++}',
  //      type: CallType.audio,
  //      status: CallStatus.incomingAnswered,
  //      startDate: DateTime.utc(2022, DateTime.february, 15, 9, 2),
  //      participants: [uSwagger],
  //      coreId: uSwagger.coreId,
  //    ),
  //  ];
  //  for (var call in calls) {
  //    callHistoryRepo.addCallToHistory(call);
  //  }
  //}

  void showDeleteAllCallsBottomSheet() {
    openDeleteAllCallHistoryBottomSheet(
      onDelete: () async {
        await callHistoryRepo.deleteAllCalls();
        calls.clear();
      },
    );
  }
}
