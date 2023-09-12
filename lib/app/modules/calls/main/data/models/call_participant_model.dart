import 'package:heyo/app/modules/calls/shared/data/models/call_user_model.dart';

enum CallParticipantStatus {
  calling,
  inCall,
}

class CallParticipantModel {
  final CallParticipantStatus status;
  final CallUserModel user;

  CallParticipantModel({
    this.status = CallParticipantStatus.calling,
    required this.user,
  });

  CallParticipantModel copyWith({
    CallParticipantStatus? status,
    CallUserModel? user,
  }) {
    return CallParticipantModel(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}
