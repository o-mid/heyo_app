import 'package:heyo/modules/features/contact/data/local_contact_repo.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';

class ContactNameUseCase {
  ContactNameUseCase({required this.contactRepository});

  final LocalContactRepo contactRepository;

  Future<String> execute(String coreId) async {
    final userModel = await contactRepository.getContactById(coreId);
    if (userModel != null) {
      //* The user is in contact
      return userModel.name;
    } else {
      //* The user is not in contact
      return coreId.shortenCoreId;
    }
  }
}
