import 'package:heyo/app/modules/calls/shared/data/models/call_model.dart';

abstract class CallHistoryAbstractProvider {
  Future<void> insert(CallModel call);

  Future<List<CallModel>> getAllCalls();

  Future<List<CallModel>> getCallsFromUserId(String userId);

  Future<void> deleteAll();

  Future<void> deleteOne(String callId);

  Future<CallModel?> getOneCall(String callId);
}
