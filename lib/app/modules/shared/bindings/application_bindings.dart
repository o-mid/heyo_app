import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/bindings/priority_bindings_interface.dart';
import 'package:heyo/app/modules/shared/controllers/app_lifecyle_controller.dart';

class ApplicationBindings with NormalPriorityBindings {
  @override
  void executeNormalPriorityBindings() {
    Get.put(AppLifeCycleController());
  }
}
