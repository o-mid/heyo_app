import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:heyo/app/modules/calls/domain/call_repository.dart';
import 'package:heyo/app/modules/calls/domain/models.dart';
import 'package:heyo/app/modules/calls/shared/data/models/all_participant_model.dart';
import 'package:heyo/app/modules/web-rtc/multiple_call_connection_handler.dart';

class WebRTCCallRepository implements CallRepository {
  WebRTCCallRepository({required this.callConnectionsHandler}) {
    callConnectionsHandler
      ..onLocalStream = (stream) {
        onLocalStream?.call(stream);
      }
      ..onAddRemoteStream = ((callRTCSession) {
        onAddCallStream?.call(
          CallStream(
            coreId: callRTCSession.remotePeer.remoteCoreId,
            remoteStream: callRTCSession.getStream(),
          ),
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
  Function(CallStream callStream)? onAddCallStream;
  @override
  Function(AllParticipantModel participantModel)? onChangeParticipateStream;

  bool mock = true;

  Future<void> emitMockStream() async {
    await _createMockStream("coreId");
    await _createMockStream("coreId1");
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
          ),
        )
        .toList();
  }

  @override
  Future<void> acceptCall(String callId) async {
    callConnectionsHandler.accept(callId);
    //Todo: AZ => we don't have coreId in here
    //_addParticipate(coreId);
  }

  @override
  Future<void> addMember(String coreId) async {
    callConnectionsHandler.addMember(coreId);
    _addToAllParticipant(coreId);
    //if (mock) {
    //  //TODO remove Mock
    //  await Future<void>.delayed(const Duration(seconds: 5));
    //  onAddCallStream?.call(
    //    CallStream(
    //      coreId: 'coreId',
    //      remoteStream: await _createMockStream(),
    //    ),
    //  );
    //await _addToAllParticipant(coreId);
    //}
  }

  @override
  Future<void> closeCall() async {
    await callConnectionsHandler.close();
    onAddCallStream = null;
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
  void showLocalVideoStream(bool value, String? sessionId, bool sendSignal) {
    callConnectionsHandler.showLocalVideoStream(value);
    //TODO signaling
  }

  @override
  Future<String> startCall(String remoteId, bool isAudioCall) async {
    final session =
        await callConnectionsHandler.requestCall(remoteId, isAudioCall);
    //Todo: AZ => we don't have coreId in here
    //_addToAllParticipant(coreId);
    return session.callId;
  }

  void _addToAllParticipant(String coreId) {
    const mockProfileImage =
        'https://raw.githubusercontent.com/Zunawe/identicons/HEAD/examples/poly.png';

    //* it will notify the onChangeParticipateStream
    onChangeParticipateStream?.call(
      AllParticipantModel(
        coreId: coreId,
        name: coreId,
        iconUrl: mockProfileImage,
        status: CallParticipantStatus.accepted,
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
    _addToAllParticipant(coreId);
    onAddCallStream?.call(
      CallStream(
        coreId: coreId,
        remoteStream: await _createStream('video', false),
      ),
    );
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
