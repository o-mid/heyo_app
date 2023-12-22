import 'package:heyo/app/modules/calls/data/call_status_provider.dart';
import 'package:heyo/app/modules/calls/data/rtc/models.dart';
import 'package:heyo/app/modules/calls/data/rtc/multiple_call_connection_handler.dart';
import 'package:heyo/app/modules/connection/domain/connection_contractor.dart';
import 'package:heyo/app/modules/connection/domain/connection_models.dart';

class CallRequestsProcessor {
  CallRequestsProcessor({
    required this.connectionContractor,
    required this.callConnectionsHandler,
    required this.callStatusProvider,
  }) {
    connectionContractor.getMessageStream().listen((event) {
      if (event is CallConnectionDataReceived) {
        onRequestReceived(
          event.mapData,
          event.remoteCoreId,
          event.remotePeerId,
        );
      }
    });
  }

  final ConnectionContractor connectionContractor;
  final CallConnectionsHandler callConnectionsHandler;
  final CallStatusProvider callStatusProvider;

  Future<void> onRequestReceived(
    Map<String, dynamic> mapData,
    String remoteCoreId,
    String remotePeerId,
  ) async {
    final data = mapData['data'];

    final callId = mapData['call_id'] as String;

    final signalType = mapData['type'];
    print("onMessage, type: ${mapData['type']}");
    if(callStatusProvider.callStatus==CallStatus.none && signalType==CallSignalingCommands.request){
      callStatusProvider.inComingCallReceived(  mapData,
        data,
        RemotePeer(
          remoteCoreId: remoteCoreId,
          remotePeerId: remotePeerId,
        ),);

    }else if (callStatusProvider.callStatus==CallStatus.inCall){

    }else if(callStatusProvider.callStatus==CallStatus.inComingCall) {

    }
    if (signalType == CallSignalingCommands.request) {
      callStatusProvider.callStatus
    }
    switch (signalType) {
      case CallSignalingCommands.request:
        {
          callConnectionsHandler.onCallRequestReceived(
            mapData,
            data,
            RemotePeer(
              remoteCoreId: remoteCoreId,
              remotePeerId: remotePeerId,
            ),
          );
        }
      case CallSignalingCommands.reject:
        {
          callConnectionsHandler.onCallRequestRejected(
            mapData,
            RemotePeer(
              remoteCoreId: remoteCoreId,
              remotePeerId: remotePeerId,
            ),
          );
        }
      case CallSignalingCommands.offer:
        {
          callConnectionsHandler.onCallOfferReceived(
            callId,
            RemotePeer(
              remoteCoreId: remoteCoreId,
              remotePeerId: remotePeerId,
            ),
            data,
          );
        }
      case CallSignalingCommands.answer:
        {
          callConnectionsHandler.onCallAnswerReceived(
            callId,
            RemotePeer(remoteCoreId: remoteCoreId, remotePeerId: remotePeerId),
            data,
          );
        }
      case CallSignalingCommands.candidate:
        {
          callConnectionsHandler.onCallCandidateReceived(
            callId,
            RemotePeer(
              remoteCoreId: remoteCoreId,
              remotePeerId: remotePeerId,
            ),
            data,
          );
        }
      case CallSignalingCommands.newMember:
        {
          callConnectionsHandler.onNewMemberEventReceived(callId, data);
        }
      case CallSignalingCommands.cameraStateChanged:
        {
          callConnectionsHandler.onCameraStateChanged(
            callId,
            data,
            RemotePeer(
              remoteCoreId: remoteCoreId,
              remotePeerId: remotePeerId,
            ),
          );
        }
    }
  }
}
