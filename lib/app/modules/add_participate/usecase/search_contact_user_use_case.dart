import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/shared/data/repository/crypto_account/account_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/utils/extensions/string.extension.dart';

class SearchContactUserUseCase {
  final ContactRepository contactRepository;
  final AccountRepository accountInfoRepo;

  SearchContactUserUseCase({
    required this.accountInfoRepo,
    required this.contactRepository,
  });

  Future<List<UserModel>> execute(String query) async {
    List<UserModel> searchedItems =
        (await contactRepository.search(query)).toList();

    if (searchedItems.isEmpty) {
      final currentUserCoreId = await accountInfoRepo.getUserAddress();
      if (query.isValidCoreId() && currentUserCoreId != query) {
        //its a new user
        //TODO update fields based on correct data
        return [
          UserModel(
            name: 'unknown',
            iconUrl: "https://avatars.githubusercontent.com/u/9801359?v=4",
            walletAddress: query,
            coreId: query,
          )
        ];
      } else {
        return [];
      }
    } else {
      return searchedItems;
    }
  }
}
