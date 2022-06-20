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
    caller = UserModel(
      name: "Boiled Dancer",
      icon: "https://avatars.githubusercontent.com/u/6645136?v=4",
      isVerified: true,
      walletAddress: "CB11${List.generate(10, (index) => index)}14AB",
    );

    callConnectionController.p2pState.callState.listen((state) {
      if (state is CallEnded) {
        Get.back();
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
        args.session, args.remotePeerId, args.remoteCoreId);

    Get.offNamed(
      Routes.CALL,
      arguments: CallViewArgumentsModel(
          user: UserModel(
            name: "Boiled Dancer",
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
