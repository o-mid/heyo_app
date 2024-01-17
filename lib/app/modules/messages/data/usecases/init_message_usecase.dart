import 'package:heyo/app/modules/messages/connection/connection_repo.dart';
import 'package:heyo/app/modules/messages/connection/models/data_channel_message_model.dart';

class InitMessageUseCase {
  final ConnectionRepository connectionRepository;
  InitMessageUseCase({required this.connectionRepository});
  void execute(MessageConnectionType messageConnectionType, List<String> remoteIds) {
    connectionRepository.initConnection(messageConnectionType, remoteIds);
  }
}
