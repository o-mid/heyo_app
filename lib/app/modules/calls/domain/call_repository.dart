
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/web-rtc/models.dart';
import 'package:heyo/app/modules/web-rtc/signaling.dart';
import 'package:heyo/app/modules/calls/domain/models.dart';

abstract class CallRepository{
  MediaStream? getLocalStream();

  Function(MediaStream stream)? onLocalStream;
  List<CallStream> getRemoteStreams(String callId);
  Function(CallStream callStateViewModel)? onAddRemoteStream;


  //Function(MediaStream stream)? onAddRemoteStream;
  //Function(MediaStream stream)? onRemoveRemoteStream;

  //UI events and actions
  void showLocalVideoStream(bool value, String? sessionId, bool sendSignal);
  Future<String> startCall(
      String remoteId, bool isAudioCall);
  Future acceptCall(String callId);

  void endOrCancelCall(String callId);
  addMember(String coreId);
  void switchCamera();
  Future<void> closeCall();
  void muteMic();
}