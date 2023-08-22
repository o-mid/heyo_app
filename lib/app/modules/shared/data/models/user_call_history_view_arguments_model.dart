import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';

class UserCallHistoryViewArgumentsModel {
  final String userCoreId;
  final String? iconUrl;

  UserCallHistoryViewArgumentsModel({
    required this.userCoreId,
    required this.iconUrl,
  });
}
