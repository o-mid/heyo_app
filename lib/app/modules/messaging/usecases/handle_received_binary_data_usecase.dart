import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../messages/data/models/messages/audio_message_model.dart';

import '../../messages/data/models/messages/file_message_model.dart';
import '../../messages/data/models/messages/image_message_model.dart';
import '../../messages/data/models/messages/message_model.dart';
import '../../messages/data/models/messages/video_message_model.dart';
import '../../messages/data/repo/messages_abstract_repo.dart';
import '../../messages/data/usecases/cofirm_message_usecase.dart';
import '../../messages/utils/message_from_json.dart';
import '../controllers/messaging_connection_controller.dart';
import '../utils/binary_file_receiving_state.dart';

class HandleReceivedBinaryData {
  final MessagesAbstractRepo messagesRepo;
  final MessagingConnectionController messagingConnection =
      Get.find<MessagingConnectionController>();

  final String chatId;

  HandleReceivedBinaryData({required this.messagesRepo, required this.chatId});
  execute({required BinaryFileReceivingState? state}) async {
    Function(double progress, int totalSize)? statusUpdateCallback;
    if (state!.processingMessage) {
      print('RECEIVER: Skipping, already processing message');
      return;
    }
    state.processingMessage = true;

    var nextChunk = 0;
    var lastMessage = state.lastHandledMessage;
    if (lastMessage != null) {
      nextChunk = lastMessage.chunkStart + lastMessage.chunk.length;
    }

    var message = state.pendingMessages[nextChunk];
    if (message == null) {
      // The next chunk is not transferred yet
      print('RECEIVER: Waiting, $nextChunk chunk not available');
      state.processingMessage = false;
      return;
    }
    if (state.filename != message.filename) {
      state.processingMessage = false;
      state.reset();
      return;
    }

    print(
        'RECEIVER: Chunk received ${message.chunkStart} of ${message.fileSize} of ${message.filename}');
    var tmpFile = await state.tmpFile();
    tmpFile.writeAsBytesSync(message.chunk, mode: FileMode.append);
    var writtenLength = message.chunkStart + message.chunk.length;
    BytesBuilder builder = BytesBuilder();

    var fileCompleted = writtenLength == message.fileSize;

    var json = jsonEncode({
      "messageSize": message.messageSize,
      "type": "acknowledge",
      "acknowledgeChunk": message.chunkStart,
      "acknowledgeFile": fileCompleted,
    });

    List<int> askheader = utf8.encode(json);

    builder.add(askheader);

    Uint8List askbytes = builder.toBytes();
    messagingConnection.sendBinaryMessage(binary: askbytes);

    statusUpdateCallback?.call(writtenLength / message.fileSize, message.fileSize);
    state.pendingMessages.remove(nextChunk);

    state.lastHandledMessage = message;
    state.processingMessage = false;

    if (fileCompleted) {
      print("RECEIVER: File received: ${message.filename}");

      state.tmpFile().then((file) async {
        await saveReceivedMessage(
            receivedMessageJson: message.meta,
            chatId: chatId,
            filePath: file.path,
            fileName: message.filename);
      });
      state.reset();
    }
  }

  Future<void> saveReceivedMessage({
    required Map<String, dynamic> receivedMessageJson,
    required String chatId,
    required String filePath,
    required String fileName,
  }) async {
    Directory directory = await getApplicationDocumentsDirectory();

    MessageModel receivedMessage = messageFromJson(receivedMessageJson);
    File newfile = File("${directory.path}/$fileName");
    newfile = await File(filePath).copy(newfile.path);

    switch (receivedMessage.type) {
      case MessageContentType.image:
        receivedMessage = (receivedMessage as ImageMessageModel).copyWith(
          isLocal: true,
          url: newfile.path,
        );
        break;
      case MessageContentType.video:
        receivedMessage = (receivedMessage as VideoMessageModel).copyWith(
          isLocal: true,
          url: newfile.path,
        );
        break;

      case MessageContentType.audio:
        receivedMessage = (receivedMessage as AudioMessageModel).copyWith(
          localUrl: newfile.path,
          isFromMe: false,
        );
        break;

      case MessageContentType.file:
        receivedMessage = (receivedMessage as FileMessageModel).copyWith(
          metadata: receivedMessage.metadata.copyWith(
            path: newfile.path,
          ),
          isFromMe: false,
        );
        break;

      default:
        break;
    }

    await messagesRepo.createMessage(
        message: receivedMessage.copyWith(
          isFromMe: false,
        ),
        chatId: chatId);
    messagingConnection.confirmReceivedMessageById(messageId: receivedMessage.messageId);
    await ConfirmMessage().execute(
        confirmMessageType: ConfirmMessageType.confirmReceivedText(
            chatId: chatId, messageId: receivedMessage.messageId));

    print('RECEIVER: Message saved path: ${newfile.path}');
  }
}
