import 'package:heyo/modules/call/data/call_status_provider.dart';

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
