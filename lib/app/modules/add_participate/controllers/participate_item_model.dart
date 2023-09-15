import 'package:heyo/app/modules/calls/shared/data/models/call_user_model.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';

class ParticipateItem {
  final String name;
  final String coreId;
  final String iconUrl;
  final String walletAddress;
  final bool isVerified;
  final bool isOnline;

  ParticipateItem({
    required this.name,
    required this.coreId,
    required this.iconUrl,
    required this.isVerified,
    required this.isOnline,
    required this.walletAddress,
  });
}

extension UserModelMapper on UserModel {
  ParticipateItem mapToParticipateItem() {
    return ParticipateItem(
      name: name,
      coreId: coreId,
      iconUrl: iconUrl,
      isVerified: isVerified,
      isOnline: isOnline,
      walletAddress: walletAddress,
    );
  }
}

extension ParticipateModelMapper on ParticipateItem {
  CallUserModel mapToCallUserModel() {
    return CallUserModel(
      name: name,
      coreId: coreId,
      iconUrl: iconUrl,
      walletAddress: walletAddress,
    );
  }
}
