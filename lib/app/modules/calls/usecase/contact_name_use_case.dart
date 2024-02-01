import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';

class ContactNameUseCase {
  ContactNameUseCase({required this.contactRepository});

  final ContactRepository contactRepository;

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
