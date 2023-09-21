import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';

class ContactAvailabilityUseCase {
  final ContactRepository contactRepository;

  ContactAvailabilityUseCase({required this.contactRepository});

  Future<UserModel?> execute(String coreId) async {
    UserModel? userModel = await contactRepository.getContactById(coreId);
    return userModel;
  }
}
