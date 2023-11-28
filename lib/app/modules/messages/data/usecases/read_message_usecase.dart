import 'package:heyo/app/modules/messages/data/models/messages/confirm_message_model.dart';
import 'package:heyo/app/modules/messages/connection/connection_data_handler.dart';
import 'package:heyo/app/modules/messages/connection/connection_repo.dart';
import 'package:heyo/app/modules/messages/connection/models/data_channel_message_model.dart';

class ReadMessageUseCase {
  ReadMessageUseCase({required this.dataHandler, required this.connectionRepository});

  final DataHandler dataHandler;
  final ConnectionRepository connectionRepository;

  Future<void> execute({
    required MessageConnectionType connectionType,
    required String messageId,
    required String remoteCoreId,
  }) async {
    final messageJsonEncode = await dataHandler.getMessageJsonEncode(
      messageId: messageId,
      status: ConfirmMessageStatus.read,
      remoteCoreId: remoteCoreId,
    );

    await connectionRepository.sendTextMessage(
        messageConnectionType: connectionType, text: messageJsonEncode, remoteCoreId: remoteCoreId);
  }
}
