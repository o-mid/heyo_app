import 'package:flutter_webrtc/flutter_webrtc.dart';

class CallStream {
  String coreId;
  MediaStream? remoteStream;
  bool isAudioCall;

  CallStream(
      {required this.coreId,
      required this.remoteStream,
      required this.isAudioCall,});
}

class CallStateViewModel {
  final CallStream callStream;
  final String name;
  bool isAudioCall = false;

  CallStateViewModel({required this.callStream, required this.name});
}
