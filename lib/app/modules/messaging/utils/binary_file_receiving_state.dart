import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'data_binary_message.dart';

class BinaryFileReceivingState {
  Map<int, DataBinaryMessage> pendingMessages = {};
  DataBinaryMessage? lastHandledMessage;
  var processingMessage = false;

  String filename;
  Map<String, dynamic> meta;

  File? _tmpFile;
  Future<File> tmpFile() async {
    _tmpFile ??= await getEmptyFile(filename);
    return _tmpFile!;
  }

  BinaryFileReceivingState(this.filename, this.meta);
}

Future<File> getEmptyFile(String filename) async {
  Directory tempDir = await getTemporaryFolder();
  var now = DateTime.now().millisecondsSinceEpoch;
  var file = File("${tempDir.path}/$now/$filename");
  await file.create(recursive: true);
  return file;
}

Future<Directory> getTemporaryFolder() async {
  Directory tmpDir = await getTemporaryDirectory();
  var uri = Uri.directory(tmpDir.path);
  var dir = Directory.fromUri(uri);
  await dir.create(recursive: true);
  return dir;
}
