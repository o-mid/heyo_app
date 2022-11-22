import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';
import 'package:heyo/app/modules/shared/utils/permission_flow.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:permission_handler/permission_handler.dart';

class ShareLocationController extends GetxController {
  final _controller = Rxn<MapController>();
  final currentAddress = "".obs;
  late String chatName;

  MapController? get controller => _controller.value;

  @override
  void onInit() {
    super.onInit();
    chatName = Get.find<MessagesController>().args.user.chatModel.name;
  }

  @override
  void onReady() async {
    super.onReady();

    final isLocationPermissionGranted = await PermissionFlow(
      permission: Permission.location,
      subtitle: LocaleKeys.Permissions_location.tr,
      indicatorIcon: Assets.svg.locationOutlined.svg(
        width: 28.w,
        height: 28.w,
      ),
    ).start();

    if (!isLocationPermissionGranted) {
      Get.back();
      return;
    }

    _controller.value = MapController();
  }

  @override
  void onClose() {
    _controller.value?.dispose();
  }

  void updateCurrentAddress() async {
    // Todo: either remove address field from location messages or find a way to update address as the user changes picker location
    // final position = await controller?.getCurrentPositionAdvancedPositionPicker();
    // if (position == null) {
    //   return;
    // }
    // final place = await Nominatim.reverseSearch(
    //   lat: position.latitude,
    //   lon: position.longitude,
    //   addressDetails: true,
    // );
    //
    // currentAddress.value = NominatimAddress.fromJson(place.address ?? {}).requestStr;
  }

  void sendCurrentLocation() async {
    final currentLocation = await controller?.getCurrentPositionAdvancedPositionPicker();
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
    final currentLocation = await controller?.getCurrentPositionAdvancedPositionPicker();
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
