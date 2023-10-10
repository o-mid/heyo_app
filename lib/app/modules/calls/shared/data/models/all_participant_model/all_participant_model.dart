import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';

part 'all_participant_model.freezed.dart';

enum AllParticipantStatus {
  calling,
  rejected,
  accepted,
}

@freezed
class AllParticipantModel with _$AllParticipantModel {
  const factory AllParticipantModel({
    required String name,
    required String iconUrl,
    required String coreId,
    @Default(AllParticipantStatus.calling) AllParticipantStatus status,
  }) = _AllParticipantModel;
}

extension UserModelMapper on UserModel {
  AllParticipantModel mapToAllParticipantModel() {
    return AllParticipantModel(
      name: name,
      coreId: coreId,
      iconUrl: iconUrl,
    );
  }
}
