import 'package:flutter_webrtc/flutter_webrtc.dart';

class CallStream {
  String coreId;
  MediaStream remoteStream;

  CallStream({required this.coreId, required this.remoteStream});
}
