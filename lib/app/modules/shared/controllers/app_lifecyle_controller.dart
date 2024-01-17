import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/extensions/stream.extension.dart';

class AppLifeCycleController extends SuperController {
  final Rx<AppLifecycleState> _appLifecycleState = Rx(AppLifecycleState.resumed);

  @override
  void onDetached() {
    _appLifecycleState.value = AppLifecycleState.detached;
  }

  @override
  void onHidden() {
    _appLifecycleState.value = AppLifecycleState.hidden;
  }

  @override
  void onInactive() {
    _appLifecycleState.value = AppLifecycleState.inactive;
  }

  @override
  void onPaused() {
    _appLifecycleState.value = AppLifecycleState.paused;
  }

  @override
  void onResumed() {
    _appLifecycleState.value = AppLifecycleState.resumed;
  }

  Future<bool> waitForResumeState() async {
    if (_appLifecycleState.value == AppLifecycleState.resumed) {
      return true;
    }
    await _appLifecycleState.stream.waitForResult(
        condition: (AppLifecycleState state) {
      return state.name == _appLifecycleState.value.name;
    },);
    return true;
  }
}
