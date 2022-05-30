import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_model.dart';
import 'package:heyo/app/modules/shared/data/models/user_call_history_view_arguments_model.dart';

class UserCallHistoryController extends GetxController {
  late UserCallHistoryViewArgumentsModel args;
  final calls = <CallModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    args = Get.arguments as UserCallHistoryViewArgumentsModel;
    _addMockData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void _addMockData() {
    var index = 0;
    calls.addAll([
      CallModel(
        id: "${index++}",
        type: CallType.audio,
        status: CallStatus.incomingAnswered,
        date: DateTime.now().subtract(const Duration(minutes: 14)),
        duration: const Duration(seconds: 704),
        dataUsageMB: 542.6,
        user: args.user,
      ),
      CallModel(
        id: "${index++}",
        type: CallType.audio,
        status: CallStatus.outgoingCanceled,
        date: DateTime.now().subtract(const Duration(minutes: 37)),
        user: args.user,
      ),
      CallModel(
        id: "${index++}",
        type: CallType.video,
        status: CallStatus.incomingMissed,
        date: DateTime.utc(2022, DateTime.march, 30, 20, 32),
        user: args.user,
      ),
      CallModel(
        id: "${index++}",
        type: CallType.audio,
        status: CallStatus.outgoingDeclined,
        date: DateTime.utc(2022, DateTime.march, 30, 17, 44),
        user: args.user,
      ),
      CallModel(
        id: "${index++}",
        type: CallType.audio,
        status: CallStatus.outgoingNotAnswered,
        date: DateTime.utc(2022, DateTime.march, 29, 21, 17),
        user: args.user,
      ),
      CallModel(
        id: "${index++}",
        type: CallType.video,
        status: CallStatus.incomingMissed,
        date: DateTime.utc(2022, DateTime.march, 28, 20, 48),
        user: args.user,
      ),
      CallModel(
        id: "${index++}",
        type: CallType.audio,
        status: CallStatus.incomingAnswered,
        date: DateTime.utc(2022, DateTime.february, 16, 20, 59),
        duration: const Duration(seconds: 156),
        dataUsageMB: 55.6,
        user: args.user,
      ),
      CallModel(
        id: "${index++}",
        type: CallType.audio,
        status: CallStatus.incomingAnswered,
        date: DateTime.utc(2022, DateTime.february, 15, 9, 2),
        user: args.user,
      ),
    ]);
  }
}
