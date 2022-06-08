import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      resetFiles.add(element);
      final newfile = await saveFile(element);
      print(element.path);
      print(newfile.path);
      print(element.extension);
    });
    resetFiles.refresh();
    // Get.back();
  }

  Future<File> saveFile(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newfile = File("${appStorage.path}/${file.name}");
    return File(file.path!).copy(newfile.path);
  }

  void increment() => count.value++;
}
