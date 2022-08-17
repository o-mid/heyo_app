import 'dart:async';

import 'package:get/get.dart';
import 'package:heyo/app/modules/call_controller/call_connection_controller.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_model.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_abstract_repo.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/shared/data/models/call_history_status.dart';

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
      switch (state.callHistoryStatus) {
        case CallHistoryStatus.ringing:
          {
            await _createMissedCallRecord(
              _getUserFromCoreId(state.session.cid),
              state.session.sid,
              state.session.isAudioCall ? CallType.audio : CallType.video,
            );
            break;
          }
        case CallHistoryStatus.invite:
          {
            await _createOutgoingNotAnsweredRecord(
              _getUserFromCoreId(state.session.cid),
              state.session.sid,
              state.session.isAudioCall ? CallType.audio : CallType.video,
            );
            break;
          }
        case CallHistoryStatus.connected:
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
        case CallHistoryStatus.byeSent:
        case CallHistoryStatus.byeReceived:
          {
            final call = await callHistoryRepo.getOneCall(state.session.sid);
            if (call == null) {
              return;
            }

            final startTime = _callStartTimestamps[call.id];

            if (startTime == null) {
              await _updateCallStatusAndDuration(
                callId: call.id,
                status:
                    _determineCallStatusFromPrevAndHistory(call.status, state.callHistoryStatus),
              );
              return;
            }

            await _updateCallStatusAndDuration(
              callId: call.id,
              duration: DateTime.now().difference(startTime),
            );
            break;
          }
        case CallHistoryStatus.initial:
        case CallHistoryStatus.nop:
          break;
      }
    });
  }

  @override
  void onClose() {
    stateListener.cancel();
    super.onClose();
  }

  CallStatus? _determineCallStatusFromPrevAndHistory(
      CallStatus prevStatus, CallHistoryStatus historyStatus) {
    if (prevStatus == CallStatus.outgoingNotAnswered &&
        historyStatus == CallHistoryStatus.byeSent) {
      return CallStatus.outgoingCanceled;
    }

    if (prevStatus == CallStatus.outgoingNotAnswered &&
        historyStatus == CallHistoryStatus.byeReceived) {
      return CallStatus.outgoingDeclined;
    }

    if (prevStatus == CallStatus.incomingMissed && historyStatus == CallHistoryStatus.byeSent) {
      return CallStatus.incomingDeclined;
    }

    if (prevStatus == CallStatus.incomingMissed && historyStatus == CallHistoryStatus.byeReceived) {
      return CallStatus.incomingMissed;
    }

    return null;
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
