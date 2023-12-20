import 'package:heyo/app/modules/calls/data/rtc/models.dart';
import 'package:heyo/app/modules/calls/data/rtc/multiple_call_connection_handler.dart';

class CallHistoryState {
  CallHistoryState({
    required this.callId,
    required this.remote,
    required this.callHistoryStatus,
  });

  final String callId;
  final CallInfo remote;
  final CallHistoryStatus callHistoryStatus;
}
