import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/utils/extensions/string.extension.dart';

class SearchUserUseCase {
  final ContactRepository contactRepository;
  final AccountInfo accountInfo;

  SearchUserUseCase(
      {required this.accountInfo, required this.contactRepository});

  Future<List<UserModel>> execute(String query) async {
    List<UserModel> searchedItems =
        (await contactRepository.search(query)).toList();

    if (searchedItems.isEmpty) {
      String? currentUserCoreId = await accountInfo.getCoreId();
      if (query.isValidCoreId() && currentUserCoreId != query) {
        //its a new user
        //TODO update fields based on correct data
        return [
          UserModel(
            name: 'unknown',
            iconUrl: "",
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
