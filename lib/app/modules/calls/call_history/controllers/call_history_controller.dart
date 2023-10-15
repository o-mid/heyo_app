import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/call_history/widgets/call_log_widget.dart';
import 'package:heyo/app/modules/calls/call_history/widgets/delete_all_calls_bottom_sheet.dart';
import 'package:heyo/app/modules/calls/call_history/widgets/delete_call_history_dialog.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_history_model/call_history_model.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_abstract_repo.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';

class CallHistoryController extends GetxController {
  CallHistoryController({required this.callHistoryRepo});

  final CallHistoryAbstractRepo callHistoryRepo;

  final calls = <CallHistoryModel>[].obs;
  final animatedListKey = GlobalKey<AnimatedListState>();

  late StreamSubscription _callsStreamSubscription;

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
    calls.value = await callHistoryRepo.getAllCalls();
    _callsStreamSubscription =
        (await callHistoryRepo.getCallsStream()).listen((newCalls) {
      // remove the deleted calls
      for (int i = 0; i < calls.length; i++) {
        if (!newCalls.any((call) => call.callId == calls[i].callId)) {
          _removeAtAnimatedList(i, calls[i]);
          calls.removeAt(i);
        }
      }

      // add new calls
      for (int i = 0; i < newCalls.length; i++) {
        if (!calls.any((call) => call.callId == newCalls[i].callId)) {
          calls.insert(i, newCalls[i]);
          animatedListKey.currentState?.insertItem(i);
        }
      }

      // update calls to latest changes
      for (int i = 0; i < newCalls.length; i++) {
        calls[i] = newCalls[i];
      }
    });
  }

  Future<void> deleteCall(CallHistoryModel call) async {
    await callHistoryRepo.deleteOneCall(call.callId);
  }

  Future<bool> showDeleteCallDialog(CallHistoryModel call) async {
    await Get.dialog<bool>(
      DeleteCallHistoryDialog(deleteCall: () => deleteCall(call)),
    );
    return false;
  }

  void _removeAtAnimatedList(int index, CallHistoryModel call) {
    animatedListKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: CallLogWidget(call: call),
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
