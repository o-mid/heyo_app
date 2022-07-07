import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/web-rtc/signaling.dart';

class CallViewArgumentsModel {
  final UserModel user;
  final Session? session;
  final String? callId;

  CallViewArgumentsModel(
      {required this.session,
      required this.user,
      required this.callId});
}
