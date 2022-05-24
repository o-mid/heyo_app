import 'package:get/get.dart';
import 'package:heyo/app/modules/gallery_picker/provider/gallery_provider.dart';
import 'package:mime/mime.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryPickerController extends GetxController {
  PickerDataProvider provider = PickerDataProvider();
  late List<Map<String, dynamic>> pickedFile;
  RxList previewFiles = [].obs;

  RxBool singlePick = false.obs;
  List<String> mediaPath = [];
  final count = 0.obs;
  @override
  void onInit() {
    pickedFile = [];
    provider.onPickMax.addListener(onPickMax);
    _getPermission();
    super.onInit();
  }

  _getPermission() async {
    var result = await PhotoManager.requestPermissionExtend(
        requestOption: const PermisstionRequestOption(
            iosAccessLevel: IosAccessLevel.readWrite));
    if (result.isAuth) {
      PhotoManager.startChangeNotify();
      PhotoManager.addChangeCallback((value) {
        _refreshPathList();
      });

      if (provider.pathList.isEmpty) {
        _refreshPathList();
      }
    } else {
      /// if result is fail, you can call `PhotoManager.openSetting();`
      /// to open android/ios application's setting to get permission
      PhotoManager.openSetting();
    }
  }

  _refreshPathList() {
    PhotoManager.getAssetPathList(type: RequestType.all).then((pathList) {
      provider.resetPathList(pathList);
    });
  }

  void onPickMax() {
    Get.rawSnackbar(message: "Already pick ${provider.max} items.");
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    provider.onPickMax.removeListener(onPickMax);
    provider.pickedFile.clear();
    provider.picked.clear();
    provider.pathList.clear();
    PhotoManager.stopChangeNotify();
  }

  Future getFile(AssetEntity asset) async {
    var file = await asset.file;
    return file!.path;
  }

  void setPickedfile(List<Map<String, dynamic>> path) {
    pickedFile = path;
    previewFiles.value = pickedFile;
    previewFiles.refresh();
  }

  bool isAssetImage(String path) {
    final mimeType = lookupMimeType(path);
    return mimeType!.startsWith('image/');
  }

  void increment() => count.value++;
}
