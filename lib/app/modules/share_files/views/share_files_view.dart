import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/share_files_controller.dart';

class ShareFilesView extends GetView<ShareFilesController> {
  const ShareFilesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShareFilesView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ShareFilesView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
