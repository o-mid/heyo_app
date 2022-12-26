import 'dart:convert';

class DataBinaryMessage {
  Map<String, dynamic> header;
  List<int> chunk;
  int lengthInBytes;

  Map<String, dynamic> get meta {
    return Map<String, dynamic>.from(header['meta'] as Map? ?? <String, dynamic>{});
  }

  String get filename {
    return header['filename'] as String;
  }

  int get fileSize {
    return header['fileSize'] as int;
  }

  int get messageSize {
    return header['messageSize'] as int;
  }

  int get chunkStart {
    return header['chunkStart'] as int;
  }

  DataBinaryMessage(this.chunk, this.header, this.lengthInBytes);

  static DataBinaryMessage parse(List<int> bytes) {
    var isFileContent = false;
    List<int> chunk = [];
    List<int> headerBytes = [];
    for (var byte in bytes) {
      if (isFileContent) {
        chunk.add(byte);
      } else if (byte == '\n'.codeUnitAt(0)) {
        isFileContent = true;
      } else {
        headerBytes.add(byte);
      }
    }

    var json = utf8.decode(headerBytes);
    var header = jsonDecode(json);

    return DataBinaryMessage(chunk, header, bytes.length);
  }
}
