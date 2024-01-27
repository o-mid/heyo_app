import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_history_model/call_history_model.dart';
import 'package:heyo/generated/locales.g.dart';

class CallUtils {
  static String callTitle(CallStatus status) {
    switch (status) {
      case CallStatus.incomingMissed:
        return LocaleKeys.CallHistory_missedCall.tr;
      case CallStatus.incomingAnswered:
      case CallStatus.incomingDeclined:
        return LocaleKeys.CallHistory_incoming.tr;
      case CallStatus.outgoingAnswered:
      case CallStatus.outgoingCanceled:
      case CallStatus.outgoingDeclined:
      case CallStatus.outgoingNotAnswered:
        return LocaleKeys.CallHistory_outgoing.tr;
    }
  }

  static String callStatus(CallHistoryModel call) {
    switch (call.status) {
      case CallStatus.outgoingDeclined:
        return LocaleKeys.CallHistory_callDeclined.tr;
      case CallStatus.outgoingNotAnswered:
        return LocaleKeys.CallHistory_notAnswered.tr;
      case CallStatus.outgoingCanceled:
        return LocaleKeys.CallHistory_callCanceled.tr;

      case CallStatus.incomingAnswered:
      case CallStatus.outgoingAnswered:
        final duration = call.endDate!.difference(call.startDate);
        return "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, "0")}";

      case CallStatus.incomingMissed:
        return LocaleKeys.CallHistory_missedCall.tr;

      default:
        return '';
    }
  }
}
