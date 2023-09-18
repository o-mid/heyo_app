import 'package:heyo/app/modules/calls/shared/data/models/call_user_model.dart';

enum CallParticipantStatus {
  calling,
  inCall,
}

class CallParticipantModel {
  final CallParticipantStatus status;
  final String name;
  final String iconUrl;
  final String coreId;

  CallParticipantModel({
    this.status = CallParticipantStatus.calling,
    required this.name,
    required this.iconUrl,
    required this.coreId,
  });

  CallParticipantModel copyWith({
    CallParticipantStatus? status,
    CallUserModel? user,
  }) {
    return CallParticipantModel(
      status: status ?? this.status,
      name: name,
      iconUrl: iconUrl,
      coreId: coreId,
    );
  }
}
