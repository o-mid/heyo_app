import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/share_files/models/file_model.dart';
import 'package:path_provider/path_provider.dart';

class ShareFilesController extends GetxController {
  late TextEditingController inputController;
  RxList resetFiles = [].obs;
  final count = 0.obs;
  @override
  void onInit() {
    inputController = TextEditingController();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }

  pickFiles() async {
    final result = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.any);

    if (result == null) return;

    result.files.forEach((element) async {
      final newfile = await saveFile(element);
      resetFiles.add(FileModel(
          extension: element.extension ?? "",
          name: element.name,
          path: newfile.path,
          size: formatBytes(element.size, 1),
          timestamp: DateTime.now(),
          isImage: isImageFromString(element.extension ?? "")));
    });
    resetFiles.refresh();
    // Get.back();
  }

  Future<File> saveFile(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newfile = File("${appStorage.path}/${file.name}");
    return File(file.path!).copy(newfile.path);
  }

  String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = [
      "B",
      "KB",
      "MB",
      "GB",
    ];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  bool isImageFromString(String str) {
    if (str == "jpg" || str == "jpeg" || str == "png") {
      return true;
    } else {
      return false;
    }
  }

  void increment() => count.value++;
}
