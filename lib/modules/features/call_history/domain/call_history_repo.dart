import 'package:heyo/app/modules/calls/shared/data/models/call_history_model/call_history_model.dart';

abstract class CallHistoryRepo {
  Future<void> addCallToHistory(CallHistoryModel call);

  Future<List<CallHistoryModel>> getAllCalls();

  Future<CallHistoryModel?> getOneCall(String callId);

  Future<List<CallHistoryModel>> getCallsFromUserId(String userId);

  Future<void> deleteAllCalls();

  Future<void> deleteOneCall(String callId);

  Future<Stream<List<CallHistoryModel>>> getCallsStream();

  Future<void> updateCall(CallHistoryModel call);
}
