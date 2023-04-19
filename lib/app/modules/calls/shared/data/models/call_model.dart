import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';

/// [CallModel] document structure :
///
/// |      Variable        |    Data Type  |                         Description                        | Default Value ((N/A) = required)|
/// |----------------------|---------------|----------------------------------------------------------|--------------|
/// | id                   | String        | Unique identifier for the call.                            | N/A          |
/// | type                 |[CallType]     | The type of call (audio or video).                         | N/A          |
/// | status               |[CallStatus]   | The status of the call (incoming, outgoing, missed , ...)  | N/A          |
/// | date                 | DateTime      | The date and time of the call.                             | N/A          |
/// | user                 |[UserModel]    | The user associated with the call.                         | N/A          |
/// | duration             | Duration      | The duration of the call.                                  | Duration.zero|
/// | dataUsageMB          | double        | The amount of data used during the call in megabytes.      | 0.0          |
/// |----------------------|---------------|----------------------------------------------------------|--------------|

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
