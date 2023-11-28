import 'package:heyo/app/modules/calls/data/models.dart';
import 'package:heyo/app/modules/calls/data/rtc/multiple_call_connection_handler.dart';

class CallStatusDataStore {
  CurrentCall? currentCall;
  RequestedCalls? requestedCalls;
  IncomingCalls? incomingCalls;

  CallRTCSession? getConnection(String remoteCoreId, CallId callId) {
    for (final value in currentCall!.activeSessions) {
      if (value.callId == callId &&
          value.remotePeer.remoteCoreId == remoteCoreId) {
        return value;
      }
    }
    return null;
  }

  CurrentCall makeCall() {
    final callId = generateCallId();
    currentCall = CurrentCall(callId: callId, activeSessions: []);
    return currentCall!;
  }
  CurrentCall makeCallByCallId(CallId callId) {
    currentCall = CurrentCall(callId: callId, activeSessions: []);
    return currentCall!;
  }

  void addSession(CallRTCSession callRTCSession) {
    currentCall!.activeSessions.add(callRTCSession);
  }


}
