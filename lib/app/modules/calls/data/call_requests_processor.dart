import 'package:heyo/app/modules/calls/data/models.dart';
import 'package:heyo/app/modules/calls/data/rtc/multiple_call_connection_handler.dart';
import 'package:heyo/app/modules/connection/domain/connection_contractor.dart';
import 'package:heyo/app/modules/connection/domain/connection_models.dart';

class CallRequestsProcessor {
  CallRequestsProcessor({
    required this.connectionContractor,
    required this.callConnectionsHandler,
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

  Future<void> onRequestReceived(
    Map<String, dynamic> mapData,
    String remoteCoreId,
    String remotePeerId,
  ) async {
    final data = mapData['data'];

    final callId = mapData['call_id'] as String;

    print("onMessage, type: ${mapData['type']}");

    switch (mapData['type']) {
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
        break;
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
                  remoteCoreId: remoteCoreId, remotePeerId: remotePeerId),);
        }
    }
  }
}
