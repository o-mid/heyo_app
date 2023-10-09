import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';

enum CallParticipantStatus {
  calling,
  rejected,
  accepted,
}

class AllParticipantModel {
  AllParticipantModel({
    required this.name,
    required this.iconUrl,
    required this.coreId,
    this.status = CallParticipantStatus.calling,
  });

  final CallParticipantStatus status;
  final String name;
  final String iconUrl;
  final String coreId;
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
