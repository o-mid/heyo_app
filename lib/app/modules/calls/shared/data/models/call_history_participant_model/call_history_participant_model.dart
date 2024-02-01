// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:heyo/app/modules/calls/call_history/views/models/call_history_participant_view_model/call_history_participant_view_model.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';

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
      coreId: coreId,
      startDate: DateTime.now(),
    );
  }
}

extension CallHistoryParticipantMapper on CallHistoryParticipantModel {
  UserModel mapToUserModel() {
    return UserModel(
      name: coreId.shortenCoreId,
      coreId: coreId,
      walletAddress: coreId,
    );
  }

  CallHistoryParticipantViewModel mapToCallHistoryParticipantViewModel(
    String name,
  ) {
    return CallHistoryParticipantViewModel(
      name: name,
      coreId: coreId,
      startDate: startDate,
    );
  }
}
