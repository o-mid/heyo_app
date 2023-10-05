import 'package:flutter_webrtc/flutter_webrtc.dart';
//import 'package:get/get.dart';

//import 'package:heyo/app/modules/add_participate/controllers/participate_item_model.dart';
import 'package:heyo/app/modules/calls/main/data/models/call_participant_model.dart';

//import 'package:heyo/app/modules/web-rtc/models.dart';
//import 'package:heyo/app/modules/web-rtc/signaling.dart';
import 'package:heyo/app/modules/calls/domain/models.dart';

abstract class CallRepository {
  MediaStream? getLocalStream();

  Function(MediaStream stream)? onLocalStream;

  Future<List<CallStream>> getCallStreams();

  Function(CallStream callStream)? onAddCallStream;

  Function(CallParticipantModel participate)? onChangeParticipateStream;

  //UI events and actions
  void showLocalVideoStream(bool value, String? sessionId, bool sendSignal);

  Future<String> startCall(String remoteId, bool isAudioCall);

  Future acceptCall(String callId);

  Future<void> endOrCancelCall(String callId);

  Future<void> addMember(String coreId);

  void switchCamera();

  Future<void> closeCall();

  void rejectIncomingCall(String callId);

  void muteMic();
}
