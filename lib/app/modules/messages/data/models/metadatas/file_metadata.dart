class FileMetaData {
  static const pathSerializedName = 'path';
  static const nameSerializedName = 'name';
  static const extensionSerializedName = 'extension';
  static const sizeSerializedName = 'size';
  static const timestampSerializedName = 'timestamp';
  static const isImageSerializedName = 'isImage';

  final String path;
  final String name;
  final String extension;
  final String size;
  final DateTime timestamp;
  final bool isImage;

  FileMetaData({
    required this.path,
    required this.name,
    required this.extension,
    required this.size,
    required this.timestamp,
    required this.isImage,
  });

  FileMetaData copyWith({
    String? path,
    String? name,
    String? extension,
    String? size,
    DateTime? timestamp,
    bool? isImage,
  }) {
    return FileMetaData(
      path: path ?? this.path,
      name: name ?? this.name,
      extension: extension ?? this.extension,
      size: size ?? this.size,
      timestamp: timestamp ?? this.timestamp,
      isImage: isImage ?? this.isImage,
    );
  }

  factory FileMetaData.fromJson(Map<String, dynamic> json) => FileMetaData(
        path: json[pathSerializedName],
        name: json[nameSerializedName],
        extension: json[extensionSerializedName],
        size: json[sizeSerializedName],
        timestamp: DateTime.parse(json[timestampSerializedName]),
        isImage: json[isImageSerializedName],
      );

  Map<String, dynamic> toJson() => {
        pathSerializedName: path,
        nameSerializedName: name,
        extensionSerializedName: extension,
        sizeSerializedName: size,
        timestampSerializedName: timestamp.toIso8601String(),
        isImageSerializedName: isImage,
      };
}
