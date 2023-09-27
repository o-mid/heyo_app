import 'package:flutter_webrtc/flutter_webrtc.dart';

class CallItemModel {
  String name;
  String coreId;
  bool audioMode;
  bool videoMode;
  String status;
  MediaStream? stream;

  CallItemModel({
    required this.name,
    required this.coreId,
    required this.audioMode,
    required this.videoMode,
    required this.status,
    this.stream,
  });

  CallItemModel copyWith({
    String? name,
    String? coreId,
    bool? audioMode,
    bool? videoMode,
    String? status,
    MediaStream? stream,
  }) {
    return CallItemModel(
      name: name ?? this.name,
      coreId: coreId ?? this.coreId,
      audioMode: audioMode ?? this.audioMode,
      videoMode: videoMode ?? this.videoMode,
      status: status ?? this.status,
      stream: stream ?? this.stream,
    );
  }

  @override
  String toString() {
    return 'CallItemModel(name: $name, coreId: $coreId, audioMode: $audioMode, videoMode: $videoMode, status: $status, stream: $stream)';
  }
}
