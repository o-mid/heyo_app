import 'package:heyo/modules/features/contact/domain/contact_repo.dart';
import 'package:heyo/modules/features/contact/domain/models/contact_model/contact_model.dart';

class SearchContactsUseCase {
  SearchContactsUseCase({required this.contactRepository});
  final ContactRepo contactRepository;

  Future<List<ContactModel>> execute(String query) async {
    return (await contactRepository.search(query)).toList();
  }
}
