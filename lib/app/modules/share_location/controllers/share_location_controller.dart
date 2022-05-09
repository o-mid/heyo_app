import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/share_location/widgets/location_permission_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

class ShareLocationController extends GetxController {
  final _controller = Rxn<MapController>();

  MapController? get controller => _controller.value;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    if (await Permission.location.isDenied) {
      final result = await Get.dialog(const LocationPermissionDialog());
      if (!result) {
        Get.back();
        return;
      }

      if (!await Permission.location.request().isGranted) {
        Get.back();
        return;
      }
    }

    _controller.value = MapController();
  }

  @override
  void onClose() {}
}
