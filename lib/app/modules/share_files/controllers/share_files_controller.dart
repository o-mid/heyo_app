import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/share_files/models/file_model.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_ios/path_provider_ios.dart' as ios_path_provider;
import 'package:path_provider_android/path_provider_android.dart'
    as android_path_provider;

class ShareFilesController extends GetxController {
  late TextEditingController inputController;
  RxList<FileModel> recentFiles = <FileModel>[].obs;
  RxList<FileModel> selectedFiles = <FileModel>[].obs;
  RxBool showSearchBar = false.obs;
  RxBool isTextInputFocused = false.obs;
  @override
  void onInit() {
    inputController = TextEditingController();
    inputController.addListener(() {
      searchFiles(inputController.text);
    });

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
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result != null) {
      if (Platform.isAndroid) {
        android_path_provider.PathProviderAndroid.registerWith();
      } else if (Platform.isIOS) {
        ios_path_provider.PathProviderIOS.registerWith();
      }

      final appStorage = await getApplicationDocumentsDirectory();
      for (var element in result.files) {
        final newfile = await saveFile(element, appStorage);
        recentFiles.insert(
            0,
            FileModel(
                extension: element.extension ?? "",
                name: element.name,
                path: newfile.path,
                size: formatBytes(element.size, 1),
                timestamp: DateTime.now(),
                isSelected: false,
                isImage: isImageFromString(element.extension ?? "")));
        selectedFiles.insert(
            0,
            FileModel(
                extension: element.extension ?? "",
                name: element.name,
                path: newfile.path,
                size: formatBytes(element.size, 1),
                timestamp: DateTime.now(),
                isSelected: false,
                isImage: isImageFromString(element.extension ?? "")));
      }
      sendSelectedFiles(selectedFiles);
    } else {
      return;
    }
  }

  Future<File> saveFile(PlatformFile file, Directory appStorage) async {
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

  RxList<FileModel> searchSuggestions = <FileModel>[].obs;
  void searchFiles(String query) {
    searchSuggestions.value = recentFiles.where((file) {
      String fileName = file.name.toLowerCase();
      String inputedQuery = query.toLowerCase();
      return fileName.contains(inputedQuery);
    }).toList();
    searchSuggestions
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    searchSuggestions.refresh();
  }

  void openFile(String filePath) {
    OpenFile.open(filePath);
  }

  void addSelectedFile(FileModel file) {
    file.isSelected = !file.isSelected;
    var selected = selectedFiles.where((e) => e.path == file.path);
    if (selected.isEmpty) {
      selectedFiles.add(file);
      selected = [];
    } else {
      selectedFiles.removeWhere((e) => e.path == file.path);
    }

    recentFiles.refresh();
    searchSuggestions.refresh();
  }

  void sendSelectedFiles(RxList<FileModel> files) {
    RxList<FileModel> tempFiles = <FileModel>[].obs;
    tempFiles.addAll(files);
    for (var element in recentFiles) {
      element.isSelected = false;
    }
    selectedFiles.clear();
    recentFiles.refresh();
    selectedFiles.refresh();

    Get.back(
      result: tempFiles,
    );
  }
}
