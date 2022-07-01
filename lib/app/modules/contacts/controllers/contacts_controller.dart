import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/models/user_contact.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';

class ContactsController extends GetxController {
  final contacts = <UserContact>[].obs;

  final ContactRepository contactRepo;

  ContactsController({required this.contactRepo});

  @override
  void onInit() async {
    super.onInit();
    contacts.value = await contactRepo.getContacts();
  }
}
