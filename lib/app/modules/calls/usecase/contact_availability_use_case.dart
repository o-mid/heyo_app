import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
import 'package:heyo/modules/features/contact/data/local_contact_repo.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';

class ContactAvailabilityUseCase {
  ContactAvailabilityUseCase({required this.contactRepository});

  final LocalContactRepo contactRepository;

  Future<UserModel> execute({
    required String coreId,
    String? name,
    String? iconUrl,
  }) async {
    final userModel = await contactRepository.getContactById(coreId);
    if (userModel != null) {
      //* The user is in contact
      return userModel;
    } else {
      //* The user is not in contact
      return UserModel(
        coreId: coreId,
        name: name ?? coreId.shortenCoreId,
        walletAddress: coreId,
      );
    }
  }
}
