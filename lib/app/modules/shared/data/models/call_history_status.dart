import 'package:heyo/app/modules/calls/data/call_status_provider.dart';
import 'package:heyo/app/modules/calls/data/rtc/models.dart';

class CallHistoryState {
  CallHistoryState({
    required this.callId,
    required this.remote,
    required this.callHistoryStatus,
    required this.isAudioCall
  });

  final String callId;
  final String remote;
  final CallHistoryStatus callHistoryStatus;
  bool? isAudioCall;
}
