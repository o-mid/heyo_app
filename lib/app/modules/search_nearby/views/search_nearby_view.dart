import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/search_nearby_controller.dart';

class SearchNearbyView extends GetView<SearchNearbyController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'SearchNearbyView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
