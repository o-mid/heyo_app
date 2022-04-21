import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_contacts_controller.dart';

class AddContactsView extends GetView<AddContactsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AddContactsView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          controller.args.user.name,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
