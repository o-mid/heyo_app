import 'package:heyo/app/modules/calls/shared/data/models/call_history_model/call_history_model.dart';

class UserCallHistoryViewArgumentsModel {
  UserCallHistoryViewArgumentsModel({
    required this.callId,
    required this.participants,
  });

  final String callId;
  final List<String> participants;
}
