import 'dart:typed_data';

enum sendingStatus {
  start,
  sending,
  end,
}

class BineryMetadata {
  static const totalBinerySizeSerializedName = 'totalSize';
  static const uint8ListSerializedName = 'uint8List';
  static const chunkSizeSerializedName = 'chunkSize';
  static const statusSerializedName = 'status';
  final Uint8List? uint8List;
  final int totalBinerySize;
  final int chunkSize;
  final sendingStatus status;

  BineryMetadata({
    required this.totalBinerySize,
    this.uint8List,
    required this.status,
    this.chunkSize = 16384,
  });

  factory BineryMetadata.fromJson(Map<String, dynamic> json) => BineryMetadata(
        totalBinerySize: json[totalBinerySizeSerializedName],
        uint8List: json[uint8ListSerializedName],
        chunkSize: json[chunkSizeSerializedName],
        status: sendingStatus.values.byName(json[statusSerializedName]),
      );

  Map<String, dynamic> toJson() => {
        totalBinerySizeSerializedName: totalBinerySize,
        uint8ListSerializedName: uint8List,
        chunkSizeSerializedName: chunkSize,
        statusSerializedName: status.name,
      };
}
