import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';

enum CallParticipantStatus {
  calling,
  inCall,
}

class CallParticipantModel {
  final CallParticipantStatus status;
  final UserModel user;

  CallParticipantModel({
    this.status = CallParticipantStatus.calling,
    required this.user,
  });

  CallParticipantModel copyWith({
    CallParticipantStatus? status,
    UserModel? user,
  }) {
    return CallParticipantModel(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}
