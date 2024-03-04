// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_history_participant_model/call_history_participant_model.dart';

part 'call_history_model.freezed.dart';
part 'call_history_model.g.dart';

enum CallType {
  audio,
  video,
}

enum CallStatus {
  incomingMissed,
  incomingAnswered,
  incomingDeclined,
  outgoingNotAnswered,
  outgoingCanceled,
  outgoingDeclined,
  outgoingAnswered,
}

@freezed
abstract class CallHistoryModel implements _$CallHistoryModel {
  @JsonSerializable(explicitToJson: true)
  const factory CallHistoryModel({
    required String callId,
    required CallType type,
    required CallStatus status,
    required List<CallHistoryParticipantModel> participants,
    required DateTime startDate,
    DateTime? endDate,
  }) = _CallHistoryModel;

  factory CallHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$CallHistoryModelFromJson(json);
}

//extension CallHistoryMapper on CallHistoryModel {
//  CallHistoryViewModel mapToCallHistoryViewModel() {
//    return CallHistoryViewModel(
//      callId: callId,
//      type: type,
//      status: status,
//      participants: participants.map((e) => e.mapToCallHistoryParticipantViewModel(name)),
//      startDate: startDate,
//      endDate: endDate,
//    );
//  }
//}
