import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';

class GetContactUserUseCase {
  final ContactRepository contactRepository;

  GetContactUserUseCase({required this.contactRepository});

  Future<List<UserModel>> execute() async {
    List<UserModel> contacts = (await contactRepository.getContacts()).toList();

    return contacts;
  }
}
