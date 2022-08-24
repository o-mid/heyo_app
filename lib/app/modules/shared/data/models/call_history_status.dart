import 'package:heyo/app/modules/web-rtc/signaling.dart';

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
  final Session session;
  final CallHistoryStatus callHistoryStatus;

  CallHistoryState({
    required this.session,
    required this.callHistoryStatus,
  });

  static CallHistoryStatus mapCallStateToCallHistoryStatus(CallState callState) {
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
      case CallState.callStateClosedCamera:
      case CallState.callStateOpendCamera:
        return CallHistoryStatus.nop;
    }
  }
}
