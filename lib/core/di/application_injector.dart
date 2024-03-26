import 'package:heyo/app/modules/shared/controllers/app_lifecyle_controller.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/core/di/priority_injector_interface.dart';

class ApplicationInjector with NormalPriorityInjector {
  @override
  void executeNormalPriorityInjector() {
    inject.registerSingleton(
      AppLifeCycleController(),
    );
  }
}
