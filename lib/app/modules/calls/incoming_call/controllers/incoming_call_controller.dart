import 'package:get/get.dart';
import 'package:heyo/app/modules/call_controller/call_state.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/incoming_call_view_arguments.dart';
import 'package:heyo/app/modules/call_controller/call_connection_controller.dart';
import 'package:heyo/app/routes/app_pages.dart';

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
      icon: "https://avatars.githubusercontent.com/u/6645136?v=4",
      isVerified: true,
      walletAddress: args.remoteCoreId,
    );

    callConnectionController.p2pState.callState.listen((state) {
      if (state is CallEnded) {
        Get.until((route)=>Get.currentRoute!=Routes.INCOMING_CALL);
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void goToChat() {
    _hangUp();
    // Todo: go to user chat
  }

  void mute() {
    muted.value = true;
    // Todo: stop ringtone
  }

  void declineCall() {
    _hangUp();
    Get.back();
  }

  void acceptCall() {
    callConnectionController.acceptCall(
        args.sdp, args.remotePeerId, args.remoteCoreId);
    //TODO name should be get from contacts
    Get.offNamed(
      Routes.CALL,
      arguments: CallViewArgumentsModel(
          callId: args.callId,
          user: UserModel(
            name: "Unknown",
            icon: "https://avatars.githubusercontent.com/u/6645136?v=4",
            isVerified: true,
            walletAddress: args.remoteCoreId,
          ),
          initiateCall: false),
    );
  }

  void _hangUp() {
    callConnectionController.rejectCall(args.remotePeerId, args.remoteCoreId);
  }
}
