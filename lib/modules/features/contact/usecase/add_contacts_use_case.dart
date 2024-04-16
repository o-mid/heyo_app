import 'package:heyo/modules/features/contact/domain/contact_repo.dart';
import 'package:heyo/modules/features/contact/domain/models/contact_model/contact_model.dart';

class AddContactUseCase {
  AddContactUseCase({required this.contactRepository});
  final ContactRepo contactRepository;

  Future<void> execute(ContactModel contact) async {
    await contactRepository.addContact(contact);
  }
}
