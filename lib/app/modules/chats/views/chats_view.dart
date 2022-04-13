import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chats_controller.dart';

class ChatsView extends GetView<ChatsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'ChatsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
