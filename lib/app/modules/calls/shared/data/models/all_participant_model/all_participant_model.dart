import 'package:heyo/app/modules/calls/shared/data/models/call_user_model.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';

class AllParticipantModel {
  AllParticipantModel({
    required this.name,
    required this.coreId,
    required this.iconUrl,
    required this.isVerified,
    required this.isOnline,
    required this.walletAddress,
  });

  final String name;
  final String coreId;
  final String iconUrl;
  final String walletAddress;
  final bool isVerified;
  final bool isOnline;
}

extension UserModelMapper on UserModel {
  AllParticipantModel mapToAllParticipantModel() {
    return AllParticipantModel(
      name: name,
      coreId: coreId,
      iconUrl: iconUrl,
      isVerified: isVerified,
      isOnline: isOnline,
      walletAddress: walletAddress,
    );
  }
}

extension ParticipateModelMapper on AllParticipantModel {
  CallUserModel mapToCallUserModel() {
    return CallUserModel(
      name: name,
      coreId: coreId,
      iconUrl: iconUrl,
      walletAddress: walletAddress,
    );
  }
}
