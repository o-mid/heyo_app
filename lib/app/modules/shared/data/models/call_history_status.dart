import 'package:heyo/app/modules/web-rtc/signaling.dart';

class CallHistoryState {
  final Session session;
  final CallState callState;

  CallHistoryState({
    required this.session,
    required this.callState,
  });
}
