import 'package:heyo/modules/features/contact/domain/contact_repo.dart';
import 'package:heyo/modules/features/contact/domain/models/contact_model/contact_model.dart';

class GetContactByIdUseCase {
  GetContactByIdUseCase({required this.contactRepository});

  final ContactRepo contactRepository;

  Future<ContactModel?> execute(String coreId) async {
    final contact = await contactRepository.getContactById(coreId);
    return contact;
  }
}
