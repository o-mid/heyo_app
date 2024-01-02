import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:heyo/app/modules/calls/data/rtc/models.dart';
import 'package:heyo/app/modules/calls/data/rtc/session/call_rtc_session.dart';
import 'package:heyo/app/modules/calls/data/signaling/signaling_models.dart';
import 'package:heyo/app/modules/connection/domain/connection_contractor.dart';
import 'package:heyo/app/modules/connection/domain/connection_models.dart';
import 'package:heyo/app/modules/shared/data/models/notification_type.dart';
import 'package:heyo/app/modules/shared/data/providers/notifications/notification_provider.dart';
import 'package:heyo/app/modules/shared/data/repository/crypto_account/account_repository.dart';

class CallSignaling {
  CallSignaling(
      {required this.connectionContractor, required this.notificationProvider,required this.accountRepository});

  final ConnectionContractor connectionContractor;
  final NotificationProvider notificationProvider;
  final JsonEncoder _encoder = const JsonEncoder();
  final AccountRepository accountRepository;
  Future<bool> _send(String eventType,
      data,
      String remoteCoreId,
      String? remotePeerId,
      String connectionId,) async {
    print(
      "onMessage send $remotePeerId : $remoteCoreId : $connectionId : $eventType : $data ",
    );
    var request = {};
    request["type"] = eventType;
    request["data"] = data;
    request["command"] = CALL_COMMAND;
    request[CALL_ID] = connectionId;
    print("P2PCommunicator: sendingSDP $remoteCoreId : $eventType");
    final requestSucceeded = await connectionContractor.sendMessage(
        _encoder.convert(request),
        RemotePeerData(remoteCoreId: remoteCoreId, remotePeerId: remotePeerId),);
    print(
      "P2PCommunicator: sendingSDP $remoteCoreId : $eventType : $requestSucceeded",
    );

    return requestSucceeded;
  }

  void requestCall(CallId callId,
      RemotePeer remotePeer,
      bool isAudioCall,
      List<String> members,) async {
    members.removeWhere(
          (element) => element == remotePeer.remoteCoreId,
    );

    final data = {};
    data["type"] = CallSignalingCommands.request;
    data["data"] = {'isAudioCall': isAudioCall, 'members': members};
    data["command"] = CALL_COMMAND;
    data[CALL_ID] = callId;
    final requestedData={};
    requestedData['content']=data;
    requestedData['id']=await accountRepository.getUserAddress();
    String content= _encoder.convert(requestedData);

    notificationProvider.sendNotification(
        remoteDelegatedCoreId: remotePeer.remoteCoreId,
        notificationType: NotificationType.missed_call,content: content,);
  }

  void sendCandidate(RTCIceCandidate iceCandidate, CallRTCSession rtcSession) {
    _send(
      CallSignalingCommands.candidate,
      {
        CallSignalingCommands.candidate: {
          'sdpMLineIndex': iceCandidate.sdpMLineIndex,
          'sdpMid': iceCandidate.sdpMid,
          'candidate': iceCandidate.candidate,
        },
      },
      rtcSession.remotePeer.remoteCoreId,
      rtcSession.remotePeer.remotePeerId,
      rtcSession.callId,
    );
  }
}
