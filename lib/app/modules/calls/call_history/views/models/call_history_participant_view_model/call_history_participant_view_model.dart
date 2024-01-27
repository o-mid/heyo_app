// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
//import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';

part 'call_history_participant_view_model.freezed.dart';
//part 'call_history_participant_view_model.g.dart';

@freezed
class CallHistoryParticipantViewModel with _$CallHistoryParticipantViewModel {
  const factory CallHistoryParticipantViewModel({
    required String name,
    required String coreId,
    required DateTime startDate,
    DateTime? endDate,
    @Default('calling') String status,
  }) = _CallHistoryParticipantViewModel;

  //factory CallHistoryParticipantViewModel.fromJson(Map<String, dynamic> json) =>
  //    _$CallHistoryParticipantViewModelFromJson(json);
}

//extension UserModelMapper on UserModel {
//  CallHistoryParticipantViewModel mapToCallHistoryParticipantViewModel() {
//    return CallHistoryParticipantViewModel(
//      name: name,
//      coreId: coreId,
//      startDate: DateTime.now(),
//    );
//  }
//}

extension CallHistoryParticipantMapper on CallHistoryParticipantViewModel {
  UserModel mapToUserModel() {
    return UserModel(
      name: name,
      coreId: coreId,
      walletAddress: coreId,
    );
  }
}
