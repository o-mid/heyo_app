import 'dart:async';
import 'dart:io';

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

  static Future<BinaryFileSendingState> create(
    File file,
    Map<String, dynamic> meta,
  ) async {
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

class SingleCompleter<T> {
  var completer = Completer<T>();

  bool get isCompleted {
    return completer.isCompleted;
  }

  Future<T> get future {
    return completer.future;
  }

  void completeError(Object error) {
    if (!completer.isCompleted) {
      completer.completeError(error);
    }
  }

  void complete(T result) {
    if (!completer.isCompleted) {
      completer.complete(result);
    }
  }
}
