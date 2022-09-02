class ImageMetadata {
  static const widthSerializedName = 'width';
  static const heightSerializedName = 'height';

  final double width;
  final double height;
  ImageMetadata({
    required this.width,
    required this.height,
  });

  factory ImageMetadata.fromJson(Map<String, dynamic> json) => ImageMetadata(
        width: json[widthSerializedName],
        height: json[heightSerializedName],
      );

  Map<String, dynamic> toJson() => {
        widthSerializedName: width,
        heightSerializedName: height,
      };
}
