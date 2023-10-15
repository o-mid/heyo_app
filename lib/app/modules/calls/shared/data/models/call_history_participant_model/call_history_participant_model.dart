// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';

part 'call_history_participant_model.freezed.dart';
part 'call_history_participant_model.g.dart';

enum CallHistoryParticipantStatus {
  calling,
  rejected,
  accepted,
}

@freezed
class CallHistoryParticipantModel with _$CallHistoryParticipantModel {
  @JsonSerializable(explicitToJson: true)
  const factory CallHistoryParticipantModel({
    required String name,
    required String iconUrl,
    required String coreId,
    required DateTime startDate,
    DateTime? endDate,
    @Default(CallHistoryParticipantStatus.calling)
    CallHistoryParticipantStatus status,
  }) = _CallHistoryParticipantModel;

  factory CallHistoryParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$CallHistoryParticipantModelFromJson(json);
}

extension UserModelMapper on UserModel {
  CallHistoryParticipantModel mapToCallHistoryParticipantModel() {
    return CallHistoryParticipantModel(
      name: name,
      coreId: coreId,
      iconUrl: iconUrl,
      startDate: DateTime.now(),
    );
  }
}
