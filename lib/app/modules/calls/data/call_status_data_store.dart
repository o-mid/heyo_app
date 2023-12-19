
import 'package:heyo/app/modules/calls/data/rtc/models.dart';
import 'package:heyo/app/modules/calls/data/rtc/session/call_rtc_session.dart';

class CallStatusDataStore {
  CurrentCall? currentCall;
  RequestedCalls? requestedCalls;
  IncomingCalls? incomingCalls;

  CallRTCSession? getConnection(String remoteCoreId, CallId callId) {
    for (final value in currentCall!.sessions) {
      if (value.callId == callId &&
          value.remotePeer.remoteCoreId == remoteCoreId) {
        return value;
      }
    }
    return null;
  }

  CurrentCall makeCall() {
    final callId = generateCallId();
    currentCall = CurrentCall(callId: callId, sessions: []);
    return currentCall!;
  }
  CurrentCall makeCallByIncomingCall() {
    currentCall = CurrentCall(callId: incomingCalls!.callId, sessions: []);
    return currentCall!;
  }

  void addSession(CallRTCSession callRTCSession) {
    currentCall!.sessions.add(callRTCSession);
  }


}
