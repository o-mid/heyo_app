import 'dart:async';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:heyo/app/modules/calls/domain/models.dart';
import 'package:heyo/app/modules/calls/shared/data/models/all_participant_model/all_participant_model.dart';

abstract class CallRepository {
  MediaStream? getLocalStream();

  Function(String coreId)? onRemoveStream;
  Function(MediaStream stream)? onLocalStream;

  Future<List<CallStream>> getCallStreams();

  Function(CallStream callStream)? onCallStreamReceived;

  Function(AllParticipantModel participantModel)? onChangeParticipateStream;

  //void notifyParticipantsChange(AllParticipantModel participant);

  //UI events and actions
  void showLocalVideoStream(bool videMode,bool sendSignal);

  Future<String> startCall(String remoteId, bool isAudioCall);

  Future<void> acceptCall(String callId);

  Future<void> endOrCancelCall(String callId);

  Future<void> addMember(String coreId);

  void switchCamera();

  Future<void> closeCall();

  void rejectIncomingCall(String callId);

  void muteMic();
}
