import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/modules/features/contact/domain/contact_repo.dart';

class ContactNameUseCase {
  ContactNameUseCase({required this.contactRepository});

  final ContactRepo contactRepository;

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
