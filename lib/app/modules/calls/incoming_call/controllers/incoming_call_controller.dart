import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/shared/data/models/call_user_model.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/incoming_call_view_arguments.dart';
import 'package:heyo/app/modules/call_controller/call_connection_controller.dart';
import 'package:heyo/app/routes/app_pages.dart';

class IncomingCallController extends GetxController {
  late CallUserModel caller;
  final muted = false.obs;
  final CallConnectionController callConnectionController;
  late IncomingCallViewArguments args;
  late String userName;
  IncomingCallController({required this.callConnectionController});

  @override
  void onInit() {
    args = Get.arguments as IncomingCallViewArguments;

    if (args.name == null) {
      userName =
          "${args.remoteCoreId.characters.take(4).string}...${args.remoteCoreId.characters.takeLast(4).string}";
    } else {
      userName = args.name!;
    }
    //TODO name should be get from contacts
    caller = CallUserModel(
      name: userName,
      isContact: (!(args.name == null)),
      iconUrl: "https://avatars.githubusercontent.com/u/6645136?v=4",
      walletAddress: args.remoteCoreId,
      coreId: args.remoteCoreId,
    );
    _playRingtone();

    super.onInit();
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

    //TODO farzam, accept
    //TODO name should be get from contacts
    Get.offNamed(
      Routes.CALL,
      arguments: CallViewArgumentsModel(
          callId: args.callId,
          enableVideo: args.isAudioCall ? false : true,
          user: CallUserModel(
            name: userName,
            iconUrl: "https://avatars.githubusercontent.com/u/6645136?v=4",
            walletAddress: args.remoteCoreId,
            coreId: args.remoteCoreId,
          ),
          isAudioCall: args.isAudioCall),
    );
  }

  void _hangUp() {
    callConnectionController.rejectCall(args.callId);
    //callConnectionController.close();
  }

  void _playRingtone() {
    FlutterRingtonePlayer.playRingtone();
  }

  void _stopRingtone() {
    FlutterRingtonePlayer.stop();
  }
}
