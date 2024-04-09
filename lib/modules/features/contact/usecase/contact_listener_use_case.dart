import 'package:heyo/modules/features/contact/domain/contact_repo.dart';
import 'package:heyo/modules/features/contact/domain/models/contact_model/contact_model.dart';

class ContactListenerUseCase {
  ContactListenerUseCase({required this.contactRepository});

  final ContactRepo contactRepository;

  Future<Stream<List<ContactModel>>> execute() async {
    final contactStream = await contactRepository.getContactsStream();
    return contactStream;
  }
}
