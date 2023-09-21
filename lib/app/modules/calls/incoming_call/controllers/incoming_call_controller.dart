import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/domain/call_repository.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_user_model.dart';
import 'package:heyo/app/modules/calls/usecase/contact_availability_use_case.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/incoming_call_view_arguments.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/routes/app_pages.dart';

class IncomingCallController extends GetxController {
  final CallRepository callRepository;
  final ContactAvailabilityUseCase contactAvailabilityUseCase;

  //TODO Call remove this model, search for it's usage in IncomingView
  Rx<CallUserModel?> caller = Rx(null);
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
        members: [args.remoteCoreId],
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
    UserModel? userModel =
        await contactAvailabilityUseCase.execute(args.remoteCoreId);

    if (userModel == null) {
      //* The user is not available in your contact
      caller.value = CallUserModel(
        name: args.remoteCoreId.shortenCoreId,
        isContact: false,
        iconUrl: "https://avatars.githubusercontent.com/u/6645136?v=4",
        walletAddress: args.remoteCoreId,
        coreId: args.remoteCoreId,
      );
    } else {
      //* The user added to your contacts before
      caller.value = userModel.toCallUserModel();
    }
  }
}
