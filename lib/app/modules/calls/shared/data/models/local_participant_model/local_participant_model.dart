import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/shared/data/models/connected_participant_model/connected_participant_model.dart';

part 'local_participant_model.freezed.dart';

@freezed
class LocalParticipantModel with _$LocalParticipantModel {
  const factory LocalParticipantModel({
    required String name,
    required String iconUrl,
    required String coreId,
    required RxBool audioMode,
    required RxBool videoMode,
    required RxBool frondCamera,
    required RxInt callDurationInSecond,
    @Default('connected') String status,
    MediaStream? stream,
    RTCVideoRenderer? rtcVideoRenderer,
  }) = _LocalParticipantModel;
}

extension ConnectedParticipateMapper on LocalParticipantModel {
  ConnectedParticipantModel mapToConnectedParticipantModel() {
    return ConnectedParticipantModel(
      name: name,
      coreId: coreId,
      iconUrl: iconUrl,
      audioMode: audioMode,
      videoMode: videoMode,
      rtcVideoRenderer: rtcVideoRenderer,
      status: status,
      stream: stream,
    );
  }
}
