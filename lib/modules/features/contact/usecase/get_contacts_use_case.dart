import 'package:heyo/modules/features/contact/domain/contact_repo.dart';
import 'package:heyo/modules/features/contact/domain/models/contact_model/contact_model.dart';

class GetContactsUseCase {
  GetContactsUseCase({required this.contactRepository});
  final ContactRepo contactRepository;

  Future<List<ContactModel>> execute() async {
    return (await contactRepository.getContacts()).toList();
  }
}
