import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';

enum CallType {
  audio,
  video,
}

enum CallStatus {
  incomingMissed,
  incomingAnswered,
  incomingDeclined,
  outgoingNotAnswered,
  outgoingCanceled,
  outgoingDeclined,
  outgoingAnswered,
}

class CallModel {
  static const idSerializedName = 'id';
  static const typeSerializedName = 'type';
  static const statusSerializedName = 'status';
  static const dateSerializedName = 'date';
  static const userSerializedName = 'user';
  static const durationSerializedName = 'duration';
  static const dataUsageMBSerializedName = 'dataUsageMB';

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

  factory CallModel.fromJson(Map<String, dynamic> json) => CallModel(
        id: json[idSerializedName],
        type: CallType.values.byName(json[typeSerializedName]),
        status: CallStatus.values.byName(json[statusSerializedName]),
        date: DateTime.parse(json[dateSerializedName]),
        user: UserModel.fromJson(json[userSerializedName]),
        duration: Duration(milliseconds: json[durationSerializedName]),
        dataUsageMB: json[dataUsageMBSerializedName],
      );

  Map<String, dynamic> toJson() => {
        idSerializedName: id,
        typeSerializedName: type.name,
        statusSerializedName: status.name,
        dateSerializedName: date.toIso8601String(),
        userSerializedName: user.toJson(),
        durationSerializedName: duration.inMilliseconds,
        dataUsageMBSerializedName: dataUsageMB,
      };

  CallModel copyWith({
    String? id,
    CallType? type,
    CallStatus? status,
    DateTime? date,
    UserModel? user,
    Duration? duration,
    double? dataUsageMB,
  }) {
    return CallModel(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      date: date ?? this.date,
      user: user ?? this.user,
      dataUsageMB: dataUsageMB ?? this.dataUsageMB,
      duration: duration ?? this.duration,
    );
  }
}
