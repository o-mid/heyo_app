import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';

enum CallType {
  audio,
  video,
}

enum CallStatus {
  incomingMissed,
  incomingAnswered,
  outgoingNotAnswered,
  outgoingCanceled,
  outgoingDeclined,
  outgoingAnswered,
}

class CallModel {
  final String id;
  final CallType type;
  final CallStatus status;
  final DateTime date;
  final UserModel user;
  final Duration duration;
  final double dataUsageMB;

  CallModel({
    required this.id,
    required this.type,
    required this.status,
    required this.date,
    required this.user,
    this.duration = Duration.zero,
    this.dataUsageMB = 0,
  });
}
