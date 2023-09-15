import 'package:heyo/app/modules/calls/domain/call_repository.dart';
import 'package:heyo/app/modules/calls/domain/models.dart';
import 'package:heyo/app/modules/web-rtc/multiple_call_connection_handler.dart';
import 'package:webrtc_interface/src/media_stream.dart';

class WebRTCCallRepository implements CallRepository {
  final CallConnectionsHandler callConnectionsHandler;
  @override
  Function(MediaStream stream)? onLocalStream;
  @override
  Function(CallStream callStateViewModel)? onAddRemoteStream;

  WebRTCCallRepository({required this.callConnectionsHandler}) {
    callConnectionsHandler.onLocalStream = ((stream) {
      onLocalStream?.call(stream);
    });
    callConnectionsHandler.onAddRemoteStream = ((callRTCSession) {
      onAddRemoteStream?.call(CallStream(
          coreId: callRTCSession.remotePeer.remoteCoreId,
          remoteStream: callRTCSession.getStream()!));
    });
  }

  @override
  List<CallStream> getRemoteStreams(String callId) {
    return callConnectionsHandler
        .getRemoteStreams()
        .map((e) =>
        CallStream(
            coreId: e.remotePeer.remoteCoreId, remoteStream: e.getStream()!))
        .toList();
  }

  @override
  @override
  Future acceptCall(String callId) async {
    callConnectionsHandler.accept(callId);
  }

  @override
  addMember(String coreId) {
    callConnectionsHandler.addMember(coreId);
  }

  @override
  Future<void> closeCall() async {
     await callConnectionsHandler.close();
     onAddRemoteStream=null;
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
    return session.callId;
  }

  @override
  void switchCamera() {
    callConnectionsHandler.switchCamera();
  }
}
