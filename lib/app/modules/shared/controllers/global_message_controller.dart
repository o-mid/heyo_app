import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class GlobalMessageController extends GetxController {
  var textController = TextEditingController();
  var scrollController = AutoScrollController();
  final streamSubscriptions = <StreamSubscription>[];

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void updateControllers() {
    textController.dispose();
    scrollController.dispose();

    textController = TextEditingController();
    scrollController = AutoScrollController();
  }

  void closeStreams() {
    streamSubscriptions.map((e) => e.cancel());
    streamSubscriptions.clear();
  }

  void reset() {
    updateControllers();
    closeStreams();
  }
}
