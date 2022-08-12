import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_model.dart';
import 'package:heyo/app/modules/calls/home/widgets/call_log_widget.dart';
import 'package:heyo/app/modules/calls/home/widgets/delete_all_calls_bottom_sheet.dart';
import 'package:heyo/app/modules/calls/home/widgets/delete_call_dialog.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_abstract_repo.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';

class CallsController extends GetxController {
  final CallHistoryAbstractRepo callHistoryRepo;

  CallsController({required this.callHistoryRepo});

  final calls = <CallModel>[].obs;
  final animatedListKey = GlobalKey<AnimatedListState>();

  late StreamSubscription _callsStreamSubscription;

  @override
  void onInit() {
    super.onInit();

    // _addMockData();
    init();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _callsStreamSubscription.cancel();
    super.onClose();
  }

  void init() async {
    calls.value = await callHistoryRepo.getAllCalls();
    _callsStreamSubscription = (await callHistoryRepo.getCallsStream()).listen((event) {
      // calls.value = event; // Todo: find a way to update animated list state as well and uncomment this
    });
  }

  void showDeleteCallDialog(CallModel call) {
    Get.dialog(
      DeleteCallDialog(
        deleteCall: () async {
          await callHistoryRepo.deleteOneCall(call.id);
          final index = calls.indexWhere((c) => c.id == call.id);
          animatedListKey.currentState?.removeItem(
            index,
            (context, animation) => SizeTransition(
              sizeFactor: animation,
              child: CallLogWidget(call: call),
            ),
          );
          calls.removeAt(index);
        },
      ),
    );
  }

  void _addMockData() {
    final uBoiled = UserModel(
      name: "Boiled Dealmaker",
      icon: "https://avatars.githubusercontent.com/u/6645136?v=4",
      isVerified: true,
      walletAddress: "CB11${List.generate(11, (index) => index).join()}14AB",
    );
    final uCrapps = UserModel(
      name: "Crapps Wallbanger",
      icon: "https://avatars.githubusercontent.com/u/2345136?v=4",
      walletAddress: "CB11${List.generate(11, (index) => index).join()}49BB",
    );
    final uFancy = UserModel(
      name: "Fancy Potato",
      icon: "https://avatars.githubusercontent.com/u/6644146?v=4",
      walletAddress: "CB11${List.generate(11, (index) => index).join()}11FE",
    );
    final uOckerito = UserModel(
      name: "Ockerito Fazola",
      icon: "https://avatars.githubusercontent.com/u/7844146?v=4",
      walletAddress: "CB11${List.generate(11, (index) => index).join()}5A5D",
      isVerified: true,
    );
    final uUnchained = UserModel(
      name: "Unchained Banana",
      icon: "https://avatars.githubusercontent.com/u/7847725?v=4",
      walletAddress: "CB11${List.generate(11, (index) => index).join()}44AC",
    );
    final uSwagger = UserModel(
      name: "Swagger Uncut",
      icon: "https://avatars.githubusercontent.com/u/9947725?v=4",
      walletAddress: "CB11${List.generate(11, (index) => index).join()}532A",
    );
    var index = 0;
    final calls = [
      CallModel(
        id: "${index++}",
        type: CallType.audio,
        status: CallStatus.outgoingCanceled,
        date: DateTime.now().subtract(const Duration(minutes: 37)),
        user: uBoiled,
      ),
      CallModel(
        id: "${index++}",
        type: CallType.video,
        status: CallStatus.incomingMissed,
        date: DateTime.utc(2022, DateTime.march, 30, 20, 32),
        user: uCrapps,
      ),
      CallModel(
        id: "${index++}",
        type: CallType.audio,
        status: CallStatus.outgoingNotAnswered,
        date: DateTime.utc(2022, DateTime.march, 30, 17, 44),
        user: uFancy,
      ),
      CallModel(
        id: "${index++}",
        type: CallType.audio,
        status: CallStatus.outgoingNotAnswered,
        date: DateTime.utc(2022, DateTime.march, 29, 21, 17),
        user: uOckerito,
      ),
      CallModel(
        id: "${index++}",
        type: CallType.video,
        status: CallStatus.incomingMissed,
        date: DateTime.utc(2022, DateTime.march, 28, 20, 48),
        user: uUnchained,
      ),
      CallModel(
        id: "${index++}",
        type: CallType.audio,
        status: CallStatus.incomingAnswered,
        date: DateTime.utc(2022, DateTime.february, 16, 20, 59),
        user: uUnchained,
      ),
      CallModel(
        id: "${index++}",
        type: CallType.audio,
        status: CallStatus.incomingAnswered,
        date: DateTime.utc(2022, DateTime.february, 15, 9, 2),
        user: uSwagger,
      ),
    ];

    for (var call in calls) {
      callHistoryRepo.addCallToHistory(call);
    }
  }

  void showDeleteAllCallsBottomSheet() {
    openDeleteAllCallsBottomSheet(
      onDelete: () async {
        await callHistoryRepo.deleteAllCalls();
        calls.clear();
      },
    );
  }
}
