import 'dart:typed_data';

class VideoMetadata {
  static const durationInSecondsSerializedName = 'durationInSeconds';
  static const thumbnailUrlSerializedName = 'thumbnailUrl';
  static const isLocalSerializedName = 'isLocal';
  static const thumbnailBytesSerializedName = 'thumbnailBytes';
  static const widthSerializedName = 'width';
  static const heightSerializedName = 'height';

  final int durationInSeconds;
  final String thumbnailUrl;
  final bool isLocal;
  Uint8List? thumbnailBytes;
  final double width;
  final double height;

  VideoMetadata({
    required this.durationInSeconds,
    required this.thumbnailUrl,
    required this.width,
    required this.height,
    required this.isLocal,
    this.thumbnailBytes,
  });

  factory VideoMetadata.fromJson(Map<String, dynamic> json) => VideoMetadata(
        durationInSeconds: json[durationInSecondsSerializedName],
        thumbnailUrl: json[thumbnailUrlSerializedName],
        isLocal: json[isLocalSerializedName],
        thumbnailBytes: json[thumbnailBytesSerializedName],
        width: json[widthSerializedName],
        height: json[heightSerializedName],
      );

  Map<String, dynamic> toJson() => {
        durationInSecondsSerializedName: durationInSeconds,
        thumbnailUrlSerializedName: thumbnailUrl,
        isLocalSerializedName: isLocal,
        thumbnailBytesSerializedName: thumbnailBytes,
        widthSerializedName: width,
        heightSerializedName: height,
      };
}
