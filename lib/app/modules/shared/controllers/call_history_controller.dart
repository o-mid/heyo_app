import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/home/controllers/calls_controller.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_model.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_abstract_repo.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';

class CallHistoryController extends GetxController {
  final CallHistoryAbstractRepo callHistoryRepo;

  CallHistoryController({required this.callHistoryRepo});

  Future<void> createMissedCallRecord(UserModel user, String callId, CallType type) async {
    final call = CallModel(
      user: user,
      status: CallStatus.incomingMissed,
      date: DateTime.now(),
      id: callId,
      type: type,
    );

    await callHistoryRepo.addCallToHistory(call);
  }

  Future<void> createOutgoingNotAnsweredRecord(UserModel user, String callId, CallType type) async {
    final call = CallModel(
      user: user,
      status: CallStatus.outgoingNotAnswered,
      date: DateTime.now(),
      id: callId,
      type: type,
    );

    await callHistoryRepo.addCallToHistory(call);
    Get.find<CallsController>().refreshCallHistory();
  }

  Future<void> updateCallStatusAndDuration({
    required String callId,
    required CallStatus status,
    Duration? duration,
  }) async {
    final call = await callHistoryRepo.getOneCall(callId);
    if (call == null) {
      return;
    }
    await callHistoryRepo.deleteOneCall(callId);
    await callHistoryRepo.addCallToHistory(
      call.copyWith(
        status: status,
        duration: duration,
      ),
    );

    Get.find<CallsController>().refreshCallHistory();
  }
}
