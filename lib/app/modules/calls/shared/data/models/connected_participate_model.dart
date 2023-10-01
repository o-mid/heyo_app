import 'package:flutter_webrtc/flutter_webrtc.dart';

class ConnectedParticipateModel {
  String name;
  String iconUrl;
  String coreId;
  bool audioMode;
  bool videoMode;
  String status;
  MediaStream? stream;
  RTCVideoRenderer? rtcVideoRenderer;

  ConnectedParticipateModel({
    required this.name,
    required this.iconUrl,
    required this.coreId,
    required this.audioMode,
    required this.videoMode,
    this.status = "connected",
    this.stream,
    this.rtcVideoRenderer,
  });

  ConnectedParticipateModel copyWith({
    String? name,
    String? iconUrl,
    String? coreId,
    bool? audioMode,
    bool? videoMode,
    String? status,
    MediaStream? stream,
    RTCVideoRenderer? rtcVideoRenderer,
  }) {
    return ConnectedParticipateModel(
      name: name ?? this.name,
      iconUrl: iconUrl ?? this.iconUrl,
      coreId: coreId ?? this.coreId,
      audioMode: audioMode ?? this.audioMode,
      videoMode: videoMode ?? this.videoMode,
      status: status ?? this.status,
      stream: stream ?? this.stream,
      rtcVideoRenderer: rtcVideoRenderer ?? this.rtcVideoRenderer,
    );
  }

  @override
  String toString() {
    return 'ConnectedParticipateModel(name: $name, iconUrl: $iconUrl, coreId: $coreId, audioMode: $audioMode, videoMode: $videoMode, status: $status, stream: $stream, rtcVideoRenderer: $rtcVideoRenderer)';
  }
}
