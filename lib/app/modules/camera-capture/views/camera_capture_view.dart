import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/camera_capture_controller.dart';

class CameraCaptureView extends GetView<CameraCaptureController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CameraCaptureView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'CameraCaptureView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
