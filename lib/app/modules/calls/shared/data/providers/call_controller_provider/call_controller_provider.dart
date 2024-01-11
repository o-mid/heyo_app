import 'package:heyo/app/modules/calls/data/rtc/models.dart';

abstract class CallControllerProvider {

  Future<void> incomingCall(CallId callId, List<CallInfo> calls);
}
