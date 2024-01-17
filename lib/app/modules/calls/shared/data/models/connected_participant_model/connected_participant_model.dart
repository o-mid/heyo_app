import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get/get.dart';

part 'connected_participant_model.freezed.dart';
//part 'connected_participate_model.g.dart';

@freezed
abstract class ConnectedParticipantModel with _$ConnectedParticipantModel {
  const factory ConnectedParticipantModel({
    required String name,
    required String coreId,
    //@RxBoolConverter() required bool audioMode,
    //@RxBoolConverter() required bool videoMode,
    required RxBool audioMode,
    required RxBool videoMode,
    @Default('connected') String status,
    MediaStream? stream,
    RTCVideoRenderer? rtcVideoRenderer,
  }) = _ConnectedParticipantModel;
}

//class RxBoolConverter implements JsonConverter<RxBool?, bool?> {
//  const RxBoolConverter();

//  @override
//  RxBool? fromJson(bool? val) {
//    return val != null ? RxBool(val) : null;
//  }

//  @override
//  bool? toJson(RxBool? val) => val?.value;
//}

//class MediaStreamSerializer {
//  static Map<String, dynamic> toJson(MediaStream? mediaStream) {
//    if (mediaStream == null) {
//      return {};
//    }

//    return {
//      'id': mediaStream.id,
//      'ownerTag': mediaStream.ownerTag,
//      // Add other properties as needed
//    };
//  }

//  static MediaStream? fromJson(Map<String, dynamic> json) {
//    if (json.isEmpty) {
//      return null;
//    }

//    return MediaStream(
//      json['id'] as String,
//      json['ownerTag'] as String,

//    );
//    // Set other properties as needed
//  }
//}
