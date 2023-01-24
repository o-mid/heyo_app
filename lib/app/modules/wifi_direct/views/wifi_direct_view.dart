import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/wifi_direct_controller.dart';

class WifiDirectView extends GetView<WifiDirectController> {
  const WifiDirectView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WifiDirectView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'WifiDirectView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
