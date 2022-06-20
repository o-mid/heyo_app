import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/models/media_view_arguments_model.dart';
import 'package:intl/intl.dart';

import '../../messages/data/models/messages/message_model.dart';

class MediaViewController extends GetxController {
  //TODO: Implement MediaViewController
  late MediaViewArgumentsModel args;
  late List<dynamic> mediaList;
  late int activeIndex;

  String? date;

  final count = 0.obs;
  @override
  void onInit() {
    args = Get.arguments as MediaViewArgumentsModel;
    mediaList = args.mediaList;
    activeIndex = args.activeIndex;
    date = DateFormat('MM/dd/yyyy, H:mm').format(mediaList.first.timestamp);

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
