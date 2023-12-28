import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/domain/call_repository.dart';
import 'package:heyo/app/modules/calls/incoming_call/controllers/incoming_call_model.dart';
import 'package:heyo/app/modules/calls/usecase/contact_availability_use_case.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/incoming_call_view_arguments.dart';
import 'package:heyo/app/routes/app_pages.dart';

class IncomingCallController extends GetxController {
  IncomingCallController({
    required this.callRepository,
    required this.contactAvailabilityUseCase,
  });

  final CallRepository callRepository;
  final ContactAvailabilityUseCase contactAvailabilityUseCase;

  RxList<IncomingCallModel> incomingCallers = RxList();
  final muted = false.obs;
  late IncomingCallViewArguments args;

  @override
  Future<void> onInit() async {
    args = Get.arguments as IncomingCallViewArguments;

<<<<<<< HEAD
    if (args.name == null) {
      userName =
          "${args.remoteCoreId.characters.take(4).string}...${args.remoteCoreId.characters.takeLast(4).string}";
    } else {
      userName = args.name!;
    }
    //TODO name should be get from contacts
    caller = UserModel(
      name: userName,
      isContact: (!(args.name == null)),
      isVerified: true,
      walletAddress: args.remoteCoreId,
      coreId: args.remoteCoreId,
    );
=======
    await getUserData();
>>>>>>> development
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

  Future<void> acceptCall() async {
    _stopRingtone();
    await callRepository.acceptCall(args.callId);
    //TODO farzam, accept
    Get.offNamed(
      Routes.CALL,
      arguments: CallViewArgumentsModel(
        callId: args.callId,
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

  Future<void> getUserData() async {
    for (final coreId in args.members) {
      final userModel =
          await contactAvailabilityUseCase.execute(coreId: coreId);

      incomingCallers.add(userModel.toIncomingCallModel());
    }
  }
}
