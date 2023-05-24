import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/models/user_contact.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';

import '../../new_chat/data/models/user_model.dart';

class ContactsController extends GetxController {
  final contacts = <UserModel>[].obs;

  final ContactRepository contactRepo;

  ContactsController({required this.contactRepo});

  @override
  void onInit() {
    super.onInit();
    getContacts();
  }

  getContacts() async {
    contacts.value = await contactRepo.getContacts();
  }
}
