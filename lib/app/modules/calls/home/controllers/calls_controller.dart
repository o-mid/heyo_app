import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_model.dart';
import 'package:heyo/app/modules/calls/home/widgets/call_log_widget.dart';
import 'package:heyo/app/modules/calls/home/widgets/delete_all_calls_bottom_sheet.dart';
import 'package:heyo/app/modules/calls/home/widgets/delete_call_dialog.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_abstract_repo.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';

import '../../../chats/data/models/chat_model.dart';

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
    _callsStreamSubscription = (await callHistoryRepo.getCallsStream()).listen((newCalls) {
      // remove the deleted calls
      for (int i = 0; i < calls.length; i++) {
        if (!newCalls.any((call) => call.id == calls[i].id)) {
          _removeAtAnimatedList(i, calls[i]);
          calls.removeAt(i);
        }
      }

      // add new calls
      for (int i = 0; i < newCalls.length; i++) {
        if (!calls.any((call) => call.id == newCalls[i].id)) {
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

  void showDeleteCallDialog(CallModel call) {
    Get.dialog(
      DeleteCallDialog(
        deleteCall: () async {
          await callHistoryRepo.deleteOneCall(call.id);
        },
      ),
    );
  }

  void _removeAtAnimatedList(int index, CallModel call) {
    animatedListKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: CallLogWidget(call: call),
      ),
    );
  }

  void _addMockData() {
    final uBoiled = UserModel(
      name: "Boiled Dealmaker",
      iconUrl: "https://avatars.githubusercontent.com/u/6645136?v=4",
      isVerified: true,
      walletAddress: "CB11${List.generate(11, (index) => index).join()}14AB",
      coreId: "CB11${List.generate(11, (index) => index).join()}14AB",
      chatModel: ChatModel(
        name: "Boiled Dealmaker",
        coreId: "CB11${List.generate(11, (index) => index).join()}14AB",
        icon: "https://avatars.githubusercontent.com/u/6645136?v=4",
        isVerified: true,
        id: "CB11${List.generate(11, (index) => index).join()}14AB",
        lastMessage: "",
        lastReadMessageId: "",
        timestamp: DateTime.now(),
      ),
    );
    final uCrapps = UserModel(
      name: "Crapps Wallbanger",
      iconUrl: "https://avatars.githubusercontent.com/u/2345136?v=4",
      walletAddress: "CB11${List.generate(11, (index) => index).join()}49BB",
      coreId: "CB11${List.generate(11, (index) => index).join()}49BB",
      chatModel: ChatModel(
        name: "Crapps Wallbanger",
        coreId: "CB11${List.generate(11, (index) => index).join()}49BB",
        icon: "https://avatars.githubusercontent.com/u/2345136?v=4",
        id: "CB11${List.generate(11, (index) => index).join()}49BB",
        lastMessage: "",
        lastReadMessageId: "",
        timestamp: DateTime.now(),
      ),
    );
    final uFancy = UserModel(
        name: "Fancy Potato",
        iconUrl: "https://avatars.githubusercontent.com/u/6644146?v=4",
        walletAddress: "CB11${List.generate(11, (index) => index).join()}11FE",
        coreId: "CB11${List.generate(11, (index) => index).join()}11FE",
        chatModel: ChatModel(
          name: "Fancy Potato",
          coreId: "CB11${List.generate(11, (index) => index).join()}11FE",
          icon: "https://avatars.githubusercontent.com/u/6644146?v=4",
          id: "CB11${List.generate(11, (index) => index).join()}11FE",
          lastMessage: "",
          lastReadMessageId: "",
          timestamp: DateTime.now(),
        ));
    final uOckerito = UserModel(
        name: "Ockerito Fazola",
        isVerified: true,
        iconUrl: "https://avatars.githubusercontent.com/u/7844146?v=4",
        walletAddress: "CB11${List.generate(11, (index) => index).join()}5A5D",
        coreId: "CB11${List.generate(11, (index) => index).join()}5A5D",
        chatModel: ChatModel(
          name: "Ockerito Fazola",
          icon: "https://avatars.githubusercontent.com/u/7844146?v=4",
          id: "CB11${List.generate(11, (index) => index).join()}5A5D",
          coreId: "CB11${List.generate(11, (index) => index).join()}5A5D",
          isVerified: true,
          lastMessage: "",
          lastReadMessageId: "",
          timestamp: DateTime.now(),
        ));
    final uUnchained = UserModel(
        name: "Unchained Banana",
        iconUrl: "https://avatars.githubusercontent.com/u/7847725?v=4",
        walletAddress: "CB11${List.generate(11, (index) => index).join()}44AC",
        coreId: "CB11${List.generate(11, (index) => index).join()}44AC",
        chatModel: ChatModel(
          name: "Unchained Banana",
          icon: "https://avatars.githubusercontent.com/u/7847725?v=4",
          id: "CB11${List.generate(11, (index) => index).join()}44AC",
          coreId: "CB11${List.generate(11, (index) => index).join()}44AC",
          lastMessage: "",
          lastReadMessageId: "",
          timestamp: DateTime.now(),
        ));
    final uSwagger = UserModel(
        name: "Swagger Uncut",
        iconUrl: "https://avatars.githubusercontent.com/u/9947725?v=4",
        walletAddress: "CB11${List.generate(11, (index) => index).join()}532A",
        coreId: "CB11${List.generate(11, (index) => index).join()}532A",
        chatModel: ChatModel(
          name: "Swagger Uncut",
          icon: "https://avatars.githubusercontent.com/u/9947725?v=4",
          id: "CB11${List.generate(11, (index) => index).join()}532A",
          coreId: "CB11${List.generate(11, (index) => index).join()}532A",
          lastReadMessageId: "",
          lastMessage: "",
          timestamp: DateTime.now(),
        ));
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
