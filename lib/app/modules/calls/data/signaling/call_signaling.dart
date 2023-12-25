import 'dart:convert';

import 'package:heyo/app/modules/calls/data/signaling/signaling_models.dart';
import 'package:heyo/app/modules/connection/domain/connection_contractor.dart';
import 'package:heyo/app/modules/connection/domain/connection_models.dart';

class CallSignaling {

  CallSignaling({required this.connectionContractor});
  final ConnectionContractor connectionContractor;
  final JsonEncoder _encoder = const JsonEncoder();

  Future<bool> _send(
      String eventType,
      String data,
      String remoteCoreId,
      String? remotePeerId,
      String connectionId,
      ) async {
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
        RemotePeerData(remoteCoreId: remoteCoreId, remotePeerId: remotePeerId));
    print(
      "P2PCommunicator: sendingSDP $remoteCoreId : $eventType : $requestSucceeded",
    );

    return requestSucceeded;
  }
}
