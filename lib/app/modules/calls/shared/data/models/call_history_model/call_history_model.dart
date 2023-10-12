import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';

part 'call_history_model.freezed.dart';
part 'call_history_model.g.dart';

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

@freezed
class CallHistoryModel with _$CallHistoryModel {
  const factory CallHistoryModel({
    required String id,
    required String coreId,
    required CallType type,
    required CallStatus status,
    required List<UserModel> participants,
    required DateTime date,
    @Default(0) double dataUsageMB,
    @Default(Duration.zero) Duration duration,
  }) = _CallHistoryModel;

  factory CallHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$CallHistoryModelFromJson(json);
}

/// [CallHistoryModel] document structure :
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

//class CallHistoryModel {
//  static const idSerializedName = 'id';
//  static const coreIdSerializedName = 'coreId';
//  static const typeSerializedName = 'type';
//  static const statusSerializedName = 'status';
//  static const dateSerializedName = 'date';
//  static const userSerializedName = 'user';
//  static const durationSerializedName = 'duration';
//  static const dataUsageMBSerializedName = 'dataUsageMB';

//  final String id;
//  final String coreId;
//  final CallType type;
//  final CallStatus status;
//  final DateTime date;
//  final UserModel user;
//  final Duration duration;
//  final double dataUsageMB;

//  CallHistoryModel({
//    required this.id,
//    required this.coreId,
//    required this.type,
//    required this.status,
//    required this.date,
//    required this.user,
//    this.duration = Duration.zero,
//    this.dataUsageMB = 0,
//  });

//  factory CallHistoryModel.fromJson(Map<String, dynamic> json) =>
//      CallHistoryModel(
//        id: json[idSerializedName] as String,
//        coreId: json[coreIdSerializedName] as String,
//        type: CallType.values.byName(json[typeSerializedName] as String),
//        status: CallStatus.values.byName(json[statusSerializedName] as String),
//        date: DateTime.parse(json[dateSerializedName] as String),
//        user: UserModel.fromJson(
//          json[userSerializedName] as Map<String, dynamic>,
//        ),
//        duration: Duration(milliseconds: json[durationSerializedName] as int),
//        dataUsageMB: json[dataUsageMBSerializedName] as double,
//      );

//  Map<String, dynamic> toJson() => {
//        idSerializedName: id,
//        coreIdSerializedName: coreId,
//        typeSerializedName: type.name,
//        statusSerializedName: status.name,
//        dateSerializedName: date.toIso8601String(),
//        userSerializedName: user.toJson(),
//        durationSerializedName: duration.inMilliseconds,
//        dataUsageMBSerializedName: dataUsageMB,
//      };

//  CallHistoryModel copyWith({
//    String? id,
//    String? coreId,
//    CallType? type,
//    CallStatus? status,
//    DateTime? date,
//    UserModel? user,
//    Duration? duration,
//    double? dataUsageMB,
//  }) {
//    return CallHistoryModel(
//      id: id ?? this.id,
//      coreId: coreId ?? this.coreId,
//      type: type ?? this.type,
//      status: status ?? this.status,
//      date: date ?? this.date,
//      user: user ?? this.user,
//      dataUsageMB: dataUsageMB ?? this.dataUsageMB,
//      duration: duration ?? this.duration,
//    );
//  }
//}
