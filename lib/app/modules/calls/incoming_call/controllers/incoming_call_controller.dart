import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/incoming_call_view_arguments.dart';
import 'package:heyo/app/modules/call_controller/call_connection_controller.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class IncomingCallController extends GetxController {
  late UserModel caller;
  final muted = false.obs;
  final CallConnectionController callConnectionController;
  late IncomingCallViewArguments args;

  IncomingCallController({required this.callConnectionController});

  @override
  void onInit() {
    super.onInit();
    args = Get.arguments as IncomingCallViewArguments;
    //TODO name should be get from contacts
    caller = UserModel(
      name: "Unknown",
      iconUrl: "https://avatars.githubusercontent.com/u/6645136?v=4",
      isVerified: true,
      walletAddress: args.remoteCoreId,
      coreId: args.remoteCoreId,
    );
    _playRingtone();
  }

  @override
  void onClose() {
    _stopRingtone();
  }

  void goToChat() {
    _hangUp();
    // Todo: go to user chat
  }

  void mute() {
    _stopRingtone();
    muted.value = true;
  }

  void declineCall() {
    _hangUp();
    _stopRingtone();
    Get.back();
  }

  void acceptCall() async {
    _stopRingtone();

    //TODO name should be get from contacts
    Get.offNamed(
      Routes.CALL,
      arguments: CallViewArgumentsModel(
          session: args.session,
          callId: args.callId,
          enableVideo: args.session.isAudioCall ? false : true,
          user: UserModel(
            name: "Unknown",
            iconUrl: "https://avatars.githubusercontent.com/u/6645136?v=4",
            isVerified: true,
            walletAddress: args.remoteCoreId,
            coreId: args.remoteCoreId,
          ),
          isAudioCall: args.session.isAudioCall),
    );
  }

  void _hangUp() {
    callConnectionController.rejectCall(args.session);
    callConnectionController.close();
  }

  void _playRingtone() {
    FlutterRingtonePlayer.playRingtone();
  }

  void _stopRingtone() {
    FlutterRingtonePlayer.stop();
  }
}
