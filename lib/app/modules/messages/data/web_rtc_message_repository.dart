import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';

import '../../shared/data/repository/contact_repository.dart';
import '../domain/message_repository.dart';
import '../domain/message_repository_models.dart';

class WebRTCMessageRepository implements MessageRepository {
  final ContactRepository contactRepository;

  WebRTCMessageRepository({required this.contactRepository});
  @override
  Future<UserModel> getUserContact({required UserInstance userInstance}) async {
    final String coreId = userInstance.coreId;
    final String? iconUrl = userInstance.iconUrl;
    // check if user is already in contact
    UserModel? createdUser = await contactRepository.getContactById(coreId);

    if (createdUser == null) {
      createdUser = UserModel(
        coreId: coreId,
        iconUrl: iconUrl ?? "https://avatars.githubusercontent.com/u/2345136?v=4",
        name: coreId.shortenCoreId,
        isOnline: true,
        isContact: false,
        walletAddress: coreId,
      );
      // adds the new user to the repo and update the UserModel
      await contactRepository.addContact(createdUser);
    }
    return createdUser;
  }
}
