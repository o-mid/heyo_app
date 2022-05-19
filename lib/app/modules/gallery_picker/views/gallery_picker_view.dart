import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/gallery_picker_controller.dart';

class GalleryPickerView extends GetView<GalleryPickerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GalleryPickerView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'GalleryPickerView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
