import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/generat_private_keys_controller.dart';

class GeneratPrivateKeysView extends GetView<GeneratPrivateKeysController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GeneratPrivateKeysView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'GeneratPrivateKeysView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
