import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:heyo/app/modules/calls/domain/models.dart';

abstract class CallRepository{
  MediaStream? getLocalStream();

  Function(MediaStream stream)? onLocalStream;
  List<CallStream> getCallStreams(String callId);
  Function(CallStream callStream)? onAddCallStream;

  //UI events and actions
  void showLocalVideoStream(bool value, String? sessionId, bool sendSignal);
  Future<String> startCall(
      String remoteId, bool isAudioCall);
  Future acceptCall(String callId);

  Future<void> endOrCancelCall(String callId);
  addMember(String coreId);
  void switchCamera();
  Future<void> closeCall();
  void rejectIncomingCall(String callId);
  void muteMic();
}