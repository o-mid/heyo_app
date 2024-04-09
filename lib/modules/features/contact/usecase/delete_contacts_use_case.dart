import 'package:heyo/modules/features/contact/domain/contact_repo.dart';

class DeleteContactsUseCase {
  DeleteContactsUseCase({required this.contactRepository});
  final ContactRepo contactRepository;

  Future<void> execute(String coreId) async {
    await contactRepository.deleteContactById(coreId);
  }
}
