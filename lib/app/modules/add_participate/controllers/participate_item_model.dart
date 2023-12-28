import '../../new_chat/data/models/user_model/user_model.dart';

class ParticipateItem {
  final String name;
  final String coreId;
  final String walletAddress;
  final bool isVerified;
  final bool isOnline;

  ParticipateItem({
    required this.name,
    required this.coreId,
    required this.isVerified,
    required this.isOnline,
    required this.walletAddress,
  });
}

extension Mapper on UserModel {
  ParticipateItem mapToParticipateItem() {
    return ParticipateItem(
      name: name,
      coreId: coreId,
      isVerified: isVerified,
      isOnline: isOnline,
      walletAddress: walletAddress,
    );
  }
}
