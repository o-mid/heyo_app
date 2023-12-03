import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/new_group_chat_controller.dart';

class NewGroupChatView extends GetView<NewGroupChatController> {
  const NewGroupChatView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NewGroupChatView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'NewGroupChatView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
