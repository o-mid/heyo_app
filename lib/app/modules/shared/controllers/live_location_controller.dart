import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LiveLocationController extends GetxController {
  StreamSubscription<Position>? positionStream;

  /// List of message ids that location is being live shared to
  final ids = <String>{};

  @override
  void onClose() {
    super.onClose();
    positionStream?.cancel();
  }

  void startSharing(String messageId, Duration duration) {
    ids.add(messageId);
    positionStream?.cancel();
    positionStream = Geolocator.getPositionStream().listen((position) {
      // Todo (libp2p): send updated location
      print(ids);
    });

    Future.delayed(duration, () {
      removeIdFromSharingList(messageId);
    });
  }

  void removeIdFromSharingList(String id) {
    ids.remove(id);
    if (ids.isEmpty) {
      _clearPositionStream();
    }
  }

  void _clearPositionStream() {
    positionStream?.cancel();
    positionStream = null;
  }
}
