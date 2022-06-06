import 'dart:typed_data';

class VideoMetadata {
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
}
