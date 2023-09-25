import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/domain/call_repository.dart';
import 'package:heyo/app/modules/calls/incoming_call/controllers/incoming_call_model.dart';
import 'package:heyo/app/modules/calls/usecase/contact_availability_use_case.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/incoming_call_view_arguments.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/routes/app_pages.dart';

class IncomingCallController extends GetxController {
  final CallRepository callRepository;
  final ContactAvailabilityUseCase contactAvailabilityUseCase;

  RxList<IncomingCallModel> incomingCallers = RxList();
  final muted = false.obs;
  late IncomingCallViewArguments args;
  // late String userName;
  IncomingCallController({
    required this.callRepository,
    required this.contactAvailabilityUseCase,
  });

  @override
  void onInit() async {
    args = Get.arguments as IncomingCallViewArguments;

    getUserData();
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
    Get.offNamed(
      Routes.CALL,
      arguments: CallViewArgumentsModel(
        callId: args.callId,
        enableVideo: args.isAudioCall ? false : true,
        isAudioCall: args.isAudioCall,
        members: args.members,
      ),
    );
  }

  void _hangUp() {
    callRepository.rejectIncomingCall(args.callId);
    //callConnectionController.close();
  }

  void _playRingtone() {
    FlutterRingtonePlayer.playRingtone();
  }

  void _stopRingtone() {
    FlutterRingtonePlayer.stop();
  }

  getUserData() async {
    for (var member in args.members) {
      UserModel? userModel = await contactAvailabilityUseCase.execute(member);

      if (userModel == null) {
        //* The user is not available in your contact
        incomingCallers.add(
          IncomingCallModel(
            name: member.shortenCoreId,
            iconUrl: "https://avatars.githubusercontent.com/u/6645136?v=4",
            coreId: member,
          ),
        );
      } else {
        //* The user added to your contacts before
        incomingCallers.add(userModel.toIncomingCallModel());
      }
    }
  }
}
