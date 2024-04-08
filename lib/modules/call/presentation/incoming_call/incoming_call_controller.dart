import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:heyo/modules/call/domain/call_repository.dart';
import 'package:heyo/modules/call/presentation/incoming_call/incoming_call_model.dart';
import 'package:heyo/app/modules/calls/usecase/contact_availability_use_case.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/incoming_call_view_arguments.dart';
import 'package:heyo/app/routes/app_pages.dart';

class IncomingCallController extends GetxController {
  IncomingCallController({
    required this.callRepository,
    required this.contactAvailabilityUseCase,
    required this.p2pState,
  });

  final CallRepository callRepository;
  final ContactAvailabilityUseCase contactAvailabilityUseCase;

  final P2PState p2pState;
  RxList<IncomingCallModel> incomingCallers = RxList();
  final muted = false.obs;
  late IncomingCallViewArguments args;
  RxBool isAdvertised = false.obs;

  @override
  Future<void> onInit() async {
    args = Get.arguments as IncomingCallViewArguments;

    await getUserData();
    _playRingtone();

    _isAdvertised();
    super.onInit();
  }

  void _isAdvertised() {
    isAdvertised.value = p2pState.advertise.value;
    p2pState.advertise.listen((p0) {
      this.isAdvertised.value = p0;
    });
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
      final contact = await contactAvailabilityUseCase.execute(coreId: coreId);

      incomingCallers.add(contact.toIncomingCallModel());
    }
  }
}
