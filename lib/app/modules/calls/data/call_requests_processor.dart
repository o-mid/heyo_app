
import 'package:heyo/app/modules/connection/domain/connection_contractor.dart';
import 'package:heyo/app/modules/connection/domain/connection_models.dart';

class CallRequestsProcessor{

  CallRequestsProcessor({required this.connectionContractor}){
    connectionContractor.getMessageStream().listen((event) {
      if (event is CallConnectionDataReceived) {
       /* onRequestReceived(
          event.mapData,
          event.remoteCoreId,
          event.remotePeerId,
        );*/
      }
    });
  }

  final ConnectionContractor connectionContractor;

}