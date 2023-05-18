import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';
import '../controllers/common_messaging_controller.dart';
import '../controllers/messaging_connection_controller.dart';
import '../utils/binary_file_sending_state.dart';
import '../utils/binary_single_completer.dart';

class SendBinaryData {
  final BinaryFileSendingState sendingState;
  int maximumMessageSize = 100000;
  SingleCompleter<bool>? messageTimeoutCompleter;
  SendBinaryData({required this.sendingState});
  final CommonMessagingConnectionController messagingConnection =
      Get.find<CommonMessagingConnectionController>();

  execute() async {
    print('SENDER: Sending first chunk...');
    sendNext();

    await sendingState.completer.future;
  }

  Future sendNext() async {
    if (sendingState.completer.isCompleted) {
      print('SENDER: Cancelled sending chunk due to completed');
      return;
    }
    try {
      var state = sendingState;
      print("SENDER: Sending chunk for ${state.filename}");

      if (state.fileSendingComplete) {
        print('SENDER: File sent completed, cancelled');
        return;
      }

      if (state.sendChunkLock) {
        print('SENDER: Already sending chunk, cancelled');
        return;
      }
      state.sendChunkLock = true;

      await sendChunk();

      state.sendChunkLock = false;
      if (!state.fileSendingComplete) {
        sendNext();
      }
      messageTimeoutCompleter?.complete(true);
      messageTimeoutCompleter = SingleCompleter();
    } catch (error) {
      messageTimeoutCompleter?.complete(true);
    }
  }

  Future sendChunk() async {
    var state = sendingState;
    var startByte = await state.raFile.position();
    print("SENDER: Sending chunk: $startByte");

    var messageHeader = {
      "filename": state.filename,
      "messageSize": maximumMessageSize,
      "chunkStart": startByte,
      "fileSize": state.fileSize,
      "meta": state.meta,
    };

    List<int> header = utf8.encode('${jsonEncode(messageHeader)}\n');

    var bytesToRead = maximumMessageSize - header.length;
    var chunk = await state.raFile.read(bytesToRead);
    var isFileRead = startByte + bytesToRead >= state.fileSize;

    var builder = BytesBuilder();
    builder.add(header);
    builder.add(chunk);
    var bytes = builder.toBytes();

    messagingConnection.sendBinaryMessage(binary: bytes);
    if (isFileRead) {
      print("SENDER: Last chunk sent");
      state.fileSendingComplete = true;
    }
  }
}
