import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
import 'package:heyo/modules/features/contact/data/local_contact_repo.dart';

class GetContactUserUseCase {
  final LocalContactRepo contactRepository;

  GetContactUserUseCase({required this.contactRepository});

  Future<List<UserModel>> execute() async {
    List<UserModel> contacts = (await contactRepository.getContacts()).toList();

    return contacts;
  }
}
