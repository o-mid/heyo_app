// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:heyo/app/modules/calls/call_history/views/models/call_history_participant_view_model/call_history_participant_view_model.dart';

part 'call_history_view_model.freezed.dart';
//part 'call_history_view_model.g.dart';

@freezed
abstract class CallHistoryViewModel implements _$CallHistoryViewModel {
  const factory CallHistoryViewModel({
    required String callId,
    required String type,
    required String status,
    required List<CallHistoryParticipantViewModel> participants,
    required DateTime startDate,
    DateTime? endDate,
  }) = _CallHistoryViewModel;

  //factory CallHistoryViewModel.fromJson(Map<String, dynamic> json) =>
  //    _$CallHistoryViewModelFromJson(json);
}
