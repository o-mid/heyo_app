import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';
import 'package:heyo/app/modules/share_location/data/models/nominatim_address.dart';
import 'package:heyo/app/modules/share_location/widgets/location_permission_dialog.dart';
import 'package:osm_nominatim/osm_nominatim.dart';
import 'package:permission_handler/permission_handler.dart';

class ShareLocationController extends GetxController {
  final _controller = Rxn<MapController>();
  final currentAddress = "".obs;
  late String chatName;

  MapController? get controller => _controller.value;

  @override
  void onInit() {
    super.onInit();
    chatName = Get.find<MessagesController>().args.chat.name;
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
  void onClose() {
    _controller.value?.dispose();
  }

  void updateCurrentAddress() async {
    final position = await controller?.myLocation();
    if (position == null) {
      return;
    }
    final place = await Nominatim.reverseSearch(
      lat: position.latitude,
      lon: position.longitude,
      addressDetails: true,
    );

    currentAddress.value = NominatimAddress.fromJson(place.address ?? {}).requestStr;
  }

  void sendCurrentLocation() async {
    final currentLocation = await controller?.myLocation();
    if (currentLocation == null) {
      return;
    }
    Get.find<MessagesController>().prepareLocationMessageForSending(
      latitude: currentLocation.latitude,
      longitude: currentLocation.longitude,
      address: currentAddress.value,
    );

    Get.back();
  }

  void startSharingLiveLocation(Duration duration) async {
    final currentLocation = await controller?.myLocation();
    if (currentLocation == null) {
      return;
    }
    Get.find<MessagesController>().sendLiveLocation(
      duration: duration,
      startLat: currentLocation.latitude,
      startLong: currentLocation.longitude,
    );

    Get.back();
  }
}
