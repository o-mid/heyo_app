import 'package:freezed_annotation/freezed_annotation.dart';

part 'call_history_state_change_model.freezed.dart';

enum CallHistoryState {
  callHistoryNew,
  callHistoryRinging,
  callHistoryInvite,
  callHistoryConnected,
  callHistoryBye,
  callHistoryBusy
}

@freezed
abstract class CallHistoryStateChangeModel with _$CallHistoryStateChangeModel {
  const factory CallHistoryStateChangeModel({
    required String callId,
    required CallHistoryState callHistoryState,
  }) = _CallHistoryStateChangeModel;
}
