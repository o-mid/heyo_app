import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';

class ParticipateItem {
  final String name;
  final String coreId;
  final String iconUrl;
  final bool isVerified;

  ParticipateItem(
      {required this.name,
      required this.coreId,
      required this.iconUrl,
      required this.isVerified});
}
extension Mapper on UserModel {

  ParticipateItem mapToParticipateItem() {
    return ParticipateItem(
        name: name,
        coreId: coreId,
        iconUrl: iconUrl,
        isVerified: isVerified);
  }
}
