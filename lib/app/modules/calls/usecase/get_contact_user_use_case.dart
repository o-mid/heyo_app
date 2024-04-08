import 'package:heyo/modules/features/contact/data/local_contact_repo.dart';
import 'package:heyo/modules/features/contact/domain/models/contact_model/contact_model.dart';

class GetContactUserUseCase {
  GetContactUserUseCase({required this.contactRepository});
  final LocalContactRepo contactRepository;

  Future<List<ContactModel>> execute() async {
    return (await contactRepository.getContacts()).toList();
  }
}
