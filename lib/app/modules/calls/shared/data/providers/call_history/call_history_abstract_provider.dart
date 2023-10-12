import 'package:heyo/app/modules/calls/shared/data/models/call_history_model/call_history_model.dart';

abstract class CallHistoryAbstractProvider {
  Future<void> insert(CallHistoryModel call);

  Future<List<CallHistoryModel>> getAllCalls();

  Future<List<CallHistoryModel>> getCallsFromUserId(String userId);

  Future<void> deleteAll();

  Future<void> deleteOne(String callId);

  Future<CallHistoryModel?> getOneCall(String callId);

  Future<Stream<List<CallHistoryModel>>> getCallsStream();

  Future<void> updateCall(CallHistoryModel call);
}
