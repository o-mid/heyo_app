import 'dart:async';
import 'dart:io';

import 'binary_single_completer.dart';

class BinaryFileSendingState {
  File file;
  RandomAccessFile raFile;
  Map<String, dynamic> meta;
  int fileSize;
  String filename;

  var completer = SingleCompleter<String>();
  var fileSendingComplete = false;
  var sendChunkLock = false;

  BinaryFileSendingState(
    this.file,
    this.raFile,
    this.filename,
    this.fileSize,
    this.meta,
  );

  static Future<BinaryFileSendingState> create({
    required File file,
    required Map<String, dynamic> meta,
  }) async {
    var name = file.uri.pathSegments.last;
    var size = await file.length();
    var raFile = await file.open();
    return BinaryFileSendingState(
      file,
      raFile,
      name,
      size,
      meta,
    );
  }
}
