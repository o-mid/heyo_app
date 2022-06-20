import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/media_view_controller.dart';

class MediaViewView extends GetView<MediaViewController> {
  const MediaViewView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MediaViewView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'MediaViewView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
