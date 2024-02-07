import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:heyo/app/modules/calls/data/rtc/multiple_call_connection_handler.dart';
import 'package:heyo/app/modules/calls/domain/call_repository.dart';
import 'package:heyo/app/modules/calls/domain/models.dart';
import 'package:heyo/app/modules/calls/shared/data/models/all_participant_model/all_participant_model.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';

class WebRTCCallRepository implements CallRepository {
  WebRTCCallRepository({required this.callConnectionsHandler}) {
    callConnectionsHandler
      ..onLocalStream = (stream) {
        onLocalStream?.call(stream);
      }
      ..onAudioStateChanged = (callRTCSession) {
        onCallStreamReceived?.call(
          CallStream(
            coreId: callRTCSession.remotePeer.remoteCoreId,
            remoteStream: callRTCSession.getStream(),
            isAudioCall: callRTCSession.isAudioCall,
          ),
        );
      }
      ..onSessionRemoved = (coreId) {
        onRemoveStream?.call(coreId);
      }
      ..onAddRemoteStream = ((callRTCSession) {
        print(
            "bbbbbbbb ioj in webrtc Repo ${callRTCSession.getStream()} : ${this.hashCode}");
        onCallStreamReceived?.call(
          CallStream(
              coreId: callRTCSession.remotePeer.remoteCoreId,
              remoteStream: callRTCSession.getStream(),
              isAudioCall: callRTCSession.isAudioCall),
        );
      });

    if (mock) {
      emitMockStream();
    }
  }

  final CallConnectionsHandler callConnectionsHandler;
  @override
  Function(MediaStream stream)? onLocalStream;
  @override
  Function(CallStream callStream)? onCallStreamReceived;
  @override
  Function(AllParticipantModel participantModel)? onChangeParticipateStream;

  @override
  Function(String coreId)? onRemoveStream;

  bool mock = false;

  Future<void> emitMockStream() async {
    //await _createMockStream("ab1005b3d01e9821e388cebbe3692e576137313fc3031");
    //await _createMockStream("ab1005b3d01e9821e388cebbe3692e576137313fc3032");
    //await _createMockStream("ab1005b3d01e9821e388cebbe3692e576137313fc3033");
    //await _createMockStream("ab1005b3d01e9821e388cebbe3692e576137313fc3034");
  }

  @override
  Future<List<CallStream>> getCallStreams() async {
    //if (mock) {
    //  return [
    //    CallStream(coreId: 'coreId', remoteStream: await _createMockStream()),
    //  ];
    //}
    return callConnectionsHandler
        .getRemoteStreams()
        .map(
          (e) => CallStream(
            coreId: e.remotePeer.remoteCoreId,
            remoteStream: e.getStream(),
            isAudioCall: e.isAudioCall,
          ),
        )
        .toList();
  }

  @override
  Future<void> acceptCall(String callId) async {
    await callConnectionsHandler.accept(callId);
    //Todo: AZ => we don't have coreId in here
    //_addParticipate(coreId);
  }

  @override
  Future<void> addMember(String coreId) async {
    await callConnectionsHandler.addMember(coreId);
    _addToAllParticipant(coreId);
  }

  @override
  Future<void> closeCall() async {
    await callConnectionsHandler.close();
    onCallStreamReceived = null;
    onLocalStream = null;
    onChangeParticipateStream = null;
  }

  @override
  Future<void> endOrCancelCall(String callId) async {
    await callConnectionsHandler.reject(callId);
  }

  @override
  MediaStream? getLocalStream() {
    return callConnectionsHandler.getLocalStream();
  }

  @override
  void muteMic() {
    callConnectionsHandler.muteMic();
  }

  @override
  void showLocalVideoStream(bool videMode, bool sendSignal) {
    callConnectionsHandler.showLocalVideoStream(videMode, sendSignal);
    //TODO signaling
  }

  @override
  Future<String> startCall(String remoteId, bool isAudioCall) async {
    final session =
        await callConnectionsHandler.createCall(remoteId, isAudioCall);
    //Todo: AZ => we don't have coreId in here
    //_addToAllParticipant(coreId);
    return session.callId;
  }

  Future<void> _addToCallStream(String coreId) async {
    onCallStreamReceived?.call(
      CallStream(
        coreId: coreId,
        remoteStream: await _createStream('video', false),
        isAudioCall: false,
      ),
    );
  }

  //Future<void> updateCallHistory({
  //  required String callId,
  //  required String coreId,
  //  required bool isAudioCall,
  //}) async {
  //  callConnectionsHandler.onCallStateChange?.call(
  //    callId,
  //    [
  //      CallInfo(
  //        remotePeer: coreId,
  //        isAudioCall: isAudioCall,
  //      ),
  //    ],
  //    CallState.callStateConnected,
  //  );
  //}

  void _addToAllParticipant(String coreId) {
    //* it will notify the onChangeParticipateStream
    onChangeParticipateStream?.call(
      AllParticipantModel(
        coreId: coreId,
        name: coreId.shortenCoreId,
      ),
    );
  }

  @override
  void switchCamera() {
    callConnectionsHandler.switchCamera();
  }

  @override
  void rejectIncomingCall(String callId) {
    callConnectionsHandler.rejectIncomingCall(callId);
  }

  Future<void> _createMockStream(String coreId) async {
    await Future<void>.delayed(const Duration(seconds: 3));
    //* Add participant to bottom sheet (All participant)
    _addToAllParticipant(coreId);
    //* Add stream participant to call (connected participant)
    await _addToCallStream(coreId);
    //*  update call history for mock
  }

  Future<MediaStream> _createStream(String media, bool userScreen) async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': userScreen
          ? true
          : {
              'mandatory': {
                'minWidth': '640',
                // Provide your own width, height and frame rate here
                'minHeight': '480',
                'minFrameRate': '30',
              },
              'facingMode': 'user',
              'optional': [],
            },
    };

    MediaStream stream = userScreen
        ? await RTCFactoryNative.instance.navigator.mediaDevices
            .getDisplayMedia(mediaConstraints)
        : await RTCFactoryNative.instance.navigator.mediaDevices
            .getUserMedia(mediaConstraints);
    return stream;
  }
}
