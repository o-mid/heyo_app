import 'package:heyo/app/modules/messaging/connection/connection_repo.dart';
import 'package:heyo/app/modules/messaging/models/data_channel_message_model.dart';

class InitMessageUseCase {
  final ConnectionRepository connectionRepository;
  InitMessageUseCase({required this.connectionRepository});
  void execute(MessageConnectionType messageConnectionType,String remoteId){
    connectionRepository.initConnection(messageConnectionType,remoteId);
  }
}
