import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/modules/features/contact/data/local_contact_repo.dart';
import 'package:heyo/modules/features/contact/domain/models/contact_model/contact_model.dart';

class ContactAvailabilityUseCase {
  ContactAvailabilityUseCase({required this.contactRepository});

  final LocalContactRepo contactRepository;

  Future<ContactModel> execute({
    required String coreId,
    String? name,
    String? iconUrl,
  }) async {
    final contact = await contactRepository.getContactById(coreId);
    if (contact != null) {
      //* The user is in contact
      return contact;
    } else {
      //* The user is not in contact
      return ContactModel(
        coreId: coreId,
        name: name ?? coreId.shortenCoreId,
      );
    }
  }
}
