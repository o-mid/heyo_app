import 'package:heyo/app/modules/calls/domain/call_repository.dart';
import 'package:heyo/app/modules/calls/domain/models.dart';
import 'package:heyo/app/modules/calls/main/data/models/call_participant_model.dart';
import 'package:heyo/app/modules/web-rtc/multiple_call_connection_handler.dart';
import 'package:webrtc_interface/src/media_stream.dart';

class WebRTCCallRepository implements CallRepository {
  final CallConnectionsHandler callConnectionsHandler;
  @override
  Function(MediaStream stream)? onLocalStream;
  @override
  Function(CallStream callStream)? onAddCallStream;
  @override
  Function(CallParticipantModel participate)? onChangeParticipateStream;

  WebRTCCallRepository({required this.callConnectionsHandler}) {
    callConnectionsHandler.onLocalStream = ((stream) {
      onLocalStream?.call(stream);
    });
    callConnectionsHandler.onAddRemoteStream = ((callRTCSession) {
      onAddCallStream?.call(CallStream(
          coreId: callRTCSession.remotePeer.remoteCoreId,
          remoteStream: callRTCSession.getStream()!));
    });
  }

  @override
  List<CallStream> getCallStreams() {
    return callConnectionsHandler
        .getRemoteStreams()
        .map(
          (e) => CallStream(
            coreId: e.remotePeer.remoteCoreId,
            remoteStream: e.getStream()!,
          ),
        )
        .toList();
  }

  @override
  Future acceptCall(String callId) async {
    callConnectionsHandler.accept(callId);
    //Todo: AZ => we don't have coreId in here
    //_addParticipate(coreId);
  }

  @override
  addMember(String coreId) {
    callConnectionsHandler.addMember(coreId);
    _addParticipate(coreId);
  }

  @override
  Future<void> closeCall() async {
    await callConnectionsHandler.close();
    onAddCallStream = null;
    onLocalStream = null;
  }

  @override
  void endOrCancelCall(String callId) {
    callConnectionsHandler.reject(callId);
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
    //_addParticipate(coreId);
    return session.callId;
  }

  void _addParticipate(String coreId) async {
    String mockProfileImage =
        "https://raw.githubusercontent.com/Zunawe/identicons/HEAD/examples/poly.png";
    onChangeParticipateStream?.call(
      CallParticipantModel(
        coreId: coreId,
        name: coreId,
        iconUrl: mockProfileImage,
      ),
    );
  }

  @override
  void switchCamera() {
    callConnectionsHandler.switchCamera();
  }
}
