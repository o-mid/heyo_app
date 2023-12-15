// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';

part 'call_history_detail_participant_model.freezed.dart';

@freezed
class CallHistoryDetailParticipantModel
    with _$CallHistoryDetailParticipantModel {
  const factory CallHistoryDetailParticipantModel({
    required String name,
    required String coreId,
    required DateTime startDate,
    DateTime? endDate,
  }) = _CallHistoryDetailParticipantModel;
}

extension UserModelMapper on UserModel {
  CallHistoryDetailParticipantModel mapToHistoryParticipantModel() {
    return CallHistoryDetailParticipantModel(
      name: name,
      coreId: coreId,
      startDate: DateTime.now(),
    );
  }
}
