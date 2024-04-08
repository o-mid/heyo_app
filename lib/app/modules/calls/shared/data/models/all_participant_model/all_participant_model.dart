// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';

part 'all_participant_model.freezed.dart';
part 'all_participant_model.g.dart';

enum AllParticipantStatus {
  calling,
  rejected,
  accepted,
}

@freezed
class AllParticipantModel with _$AllParticipantModel {
  @JsonSerializable(explicitToJson: true)
  const factory AllParticipantModel({
    required String name,
    required String coreId,
    @Default(AllParticipantStatus.calling) AllParticipantStatus status,
  }) = _AllParticipantModel;

  factory AllParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$AllParticipantModelFromJson(json);
}

//extension UserModelMapper on UserModel {
//  AllParticipantModel mapToAllParticipantModel() {
//    return AllParticipantModel(
//      name: name,
//      coreId: coreId,
//    );
//  }
//}
