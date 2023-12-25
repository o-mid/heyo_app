import 'package:heyo/app/modules/calls/data/call_status_provider.dart';
import 'package:heyo/app/modules/calls/data/rtc/models.dart';

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
