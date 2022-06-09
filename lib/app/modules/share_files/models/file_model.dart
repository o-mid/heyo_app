class FileModel {
  String path;
  String name;
  String extension;
  String size;
  DateTime timestamp;
  bool isImage;

  FileModel(
      {required this.path,
      required this.name,
      required this.extension,
      required this.size,
      required this.timestamp,
      required this.isImage});
}
