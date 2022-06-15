import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/shared/data/models/incoming_call_view_arguments.dart';
import 'package:heyo/app/modules/shared/utils/extensions/string.extension.dart';
import 'package:heyo/app/modules/call_controller/call_controller.dart';

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
        args.session.convertHexToString(), args.eventId, args.remotePeerId, args.remoteCoreId);
    //TODO you should listen to accept call response for moving to call page
    //  Get.offNamed(Routes.CALL, arguments: CallViewArgumentsModel(user: caller));
  }

  void _hangUp() {
    // Todo
  }
}
