import 'dart:typed_data';

enum sendingStatus {
  start,
  sending,
  end,
}

class BinaryMetadata {
  static const totalBinarySizeSerializedName = 'totalSize';
  static const uint8ListSerializedName = 'uint8List';
  static const chunkSizeSerializedName = 'chunkSize';
  static const statusSerializedName = 'status';
  final Uint8List? uint8List;
  final int totalBinarySize;
  final int chunkSize;
  final sendingStatus status;

  BinaryMetadata({
    required this.totalBinarySize,
    this.uint8List,
    required this.status,
    this.chunkSize = 16384,
  });

  factory BinaryMetadata.fromJson(Map<String, dynamic> json) => BinaryMetadata(
        totalBinarySize: json[totalBinarySizeSerializedName],
        uint8List: json[uint8ListSerializedName],
        chunkSize: json[chunkSizeSerializedName],
        status: sendingStatus.values.byName(json[statusSerializedName]),
      );

  Map<String, dynamic> toJson() => {
        totalBinarySizeSerializedName: totalBinarySize,
        uint8ListSerializedName: uint8List,
        chunkSizeSerializedName: chunkSize,
        statusSerializedName: status.name,
      };
}
