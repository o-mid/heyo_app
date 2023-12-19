import 'package:heyo/app/modules/calls/data/rtc/models.dart';
import 'package:heyo/app/modules/calls/data/rtc/multiple_call_connection_handler.dart';

enum CallHistoryStatus {
  nop,

  /// for mapping non important [CallState] to [CallHistoryStatus]
  initial,
  ringing,
  invite,
  connected,
  byeReceived,
  byeSent,
}

class CallHistoryState {
  CallHistoryState({
    required this.callId,
    required this.remotes,
    required this.callHistoryStatus,
  });

  final String callId;
  final List<CallInfo> remotes;
  final CallHistoryStatus callHistoryStatus;

  static CallHistoryStatus mapCallStateToCallHistoryStatus(
      CallState callState) {
    switch (callState) {
      case CallState.callStateNew:
        return CallHistoryStatus.initial;
      case CallState.callStateRinging:
        return CallHistoryStatus.ringing;
      case CallState.callStateInvite:
        return CallHistoryStatus.invite;
      case CallState.callStateConnected:
        return CallHistoryStatus.connected;
      case CallState.callStateBye:
        return CallHistoryStatus.byeReceived;
      case CallState.callStateBusy:
        return CallHistoryStatus.nop;
    }
  }
}
