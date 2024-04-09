import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/modules/features/contact/domain/contact_repo.dart';

class GetContactNameByIdUseCase {
  GetContactNameByIdUseCase({required this.contactRepository});

  final ContactRepo contactRepository;

  Future<String> execute(String coreId) async {
    final contact = await contactRepository.getContactById(coreId);
    if (contact != null) {
      //* The user is in contact
      return contact.name;
    } else {
      //* The user is not in contact
      return coreId.shortenCoreId;
    }
  }
}
