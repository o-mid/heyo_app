import 'dart:async';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:heyo/app/modules/calls/domain/models.dart';
import 'package:heyo/app/modules/calls/main/data/models/call_participant_model.dart';

abstract class CallRepository {
  MediaStream? getLocalStream();

  Function(MediaStream stream)? onLocalStream;

  Future<List<CallStream>> getCallStreams();

  Function(CallStream callStream)? onAddCallStream;

  Function(CallParticipantModel participantModel)? onChangeParticipateStream;

  //void notifyParticipantsChange(CallParticipantModel participant);

  //UI events and actions
  void showLocalVideoStream(bool value, String? sessionId, bool sendSignal);

  Future<String> startCall(String remoteId, bool isAudioCall);

  Future<void> acceptCall(String callId);

  Future<void> endOrCancelCall(String callId);

  Future<void> addMember(String coreId);

  void switchCamera();

  Future<void> closeCall();

  void rejectIncomingCall(String callId);

  void muteMic();
}
