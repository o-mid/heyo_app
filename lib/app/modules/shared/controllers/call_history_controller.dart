import 'dart:async';

import 'package:get/get.dart';
import 'package:heyo/app/modules/call_controller/call_connection_controller.dart';
import 'package:heyo/app/modules/calls/home/controllers/calls_controller.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_model.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_abstract_repo.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/web-rtc/signaling.dart';

class CallHistoryController extends GetxController {
  final CallHistoryAbstractRepo callHistoryRepo;
  final CallConnectionController callConnectionController;

  /// maps session id of a call to the time it started so that when it ends
  /// we can calculate the duration of call
  final _callStartTimestamps = <String, DateTime>{};

  late StreamSubscription stateListener;

  CallHistoryController({
    required this.callHistoryRepo,
    required this.callConnectionController,
  });

  @override
  void onInit() {
    super.onInit();
    stateListener = callConnectionController.callHistoryState.listen((state) async {
      if (state == null) {
        return;
      }
      switch (state.callState) {
        case CallState.callStateRinging:
          {
            await _createMissedCallRecord(
              _getUserFromCoreId(state.session.cid),
              state.session.sid,
              state.session.isAudioCall ? CallType.audio : CallType.video,
            );
            break;
          }
        case CallState.callStateInvite:
          {
            await _createOutgoingNotAnsweredRecord(
              _getUserFromCoreId(state.session.cid),
              state.session.sid,
              state.session.isAudioCall ? CallType.audio : CallType.video,
            );
            break;
          }
        // case CallState.callStateReject:
        //   {
        //     await _updateCallStatusAndDuration(
        //       callId: state.session.sid,
        //       status: CallStatus.incomingDeclined,
        //     );
        //     break;
        //   }
        case CallState.callStateConnected:
          {
            final call = await callHistoryRepo.getOneCall(state.session.sid);
            if (call == null) {
              return;
            }

            /// store the time call started
            _callStartTimestamps[state.session.sid] = DateTime.now();

            await _updateCallStatusAndDuration(
              callId: call.id,
              status: call.status == CallStatus.incomingMissed
                  ? CallStatus.incomingAnswered
                  : CallStatus.outgoingAnswered,
            );
            break;
          }
        case CallState.callStateBye:
          {
            final call = await callHistoryRepo.getOneCall(state.session.sid);
            if (call == null) {
              return;
            }

            final startTime = _callStartTimestamps[call.id];

            if (startTime == null) {
              return;
            }
            // Todo: find a way to differentiate between cancel and reject for outgoing and missed and reject for incoming
            // if (startTime == null && call.status == CallStatus.outgoingNotAnswered) {
            //   await _updateCallStatusAndDuration(
            //     callId: call.id,
            //     status: CallStatus.outgoingCanceled,
            //   );
            //   return;
            // }

            await _updateCallStatusAndDuration(
              callId: call.id,
              duration: DateTime.now().difference(startTime),
            );
            break;
          }
        case CallState.callStateNew:
        case CallState.callStateClosedCamera:
        case CallState.callStateOpendCamera:
          break;
      }
    });
  }

  @override
  void onClose() {
    stateListener.cancel();
    super.onClose();
  }

  Future<void> _createMissedCallRecord(UserModel user, String callId, CallType type) async {
    final call = CallModel(
      user: user,
      status: CallStatus.incomingMissed,
      date: DateTime.now(),
      id: callId,
      type: type,
    );

    await callHistoryRepo.addCallToHistory(call);

    Get.find<CallsController>().refreshCallHistory();
  }

  Future<void> _createOutgoingNotAnsweredRecord(
      UserModel user, String callId, CallType type) async {
    final call = CallModel(
      user: user,
      status: CallStatus.outgoingNotAnswered,
      date: DateTime.now(),
      id: callId,
      type: type,
    );

    await callHistoryRepo.addCallToHistory(call);
    Get.find<CallsController>().refreshCallHistory();
  }

  Future<void> _updateCallStatusAndDuration({
    required String callId,
    CallStatus? status,
    Duration? duration,
  }) async {
    final call = await callHistoryRepo.getOneCall(callId);
    if (call == null) {
      return;
    }
    await callHistoryRepo.deleteOneCall(callId);
    await callHistoryRepo.addCallToHistory(
      call.copyWith(
        status: status,
        duration: duration,
      ),
    );

    Get.find<CallsController>().refreshCallHistory();
  }

  UserModel _getUserFromCoreId(String coreId) {
    return UserModel(
      name: "Unknown",
      icon: "https://avatars.githubusercontent.com/u/6645136?v=4",
      isVerified: true,
      walletAddress: coreId,
    );
  }
}
