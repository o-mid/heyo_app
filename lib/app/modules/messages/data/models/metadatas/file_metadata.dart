class FileMetaData {
  final String path;
  final String name;
  final String extension;
  final String size;
  final DateTime timestamp;
  final bool isImage;

  FileMetaData(
      {required this.path,
      required this.name,
      required this.extension,
      required this.size,
      required this.timestamp,
      required this.isImage});
}
