import 'dart:async';

import 'package:heyo/app/modules/calls/shared/data/models/call_model.dart';
import 'package:heyo/app/modules/calls/shared/data/providers/call_history/call_history_abstract_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:sembast/sembast.dart';

import '../../../../../new_chat/data/models/user_model.dart';

class CallHistoryProvider implements CallHistoryAbstractProvider {
  final AppDatabaseProvider appDatabaseProvider;
  CallHistoryProvider({required this.appDatabaseProvider});
  static const String callHistoryStoreName = 'call_history';

  final _store = intMapStoreFactory.store(callHistoryStoreName);

  Future<Database> get _db async => await appDatabaseProvider.database;

  @override
  Future<void> insert(CallModel call) async {
    await _store.add(await _db, call.toJson());
  }

  @override
  Future<void> deleteAll() async {
    await _store.delete(await _db);
  }

  @override
  Future<void> deleteOne(String callId) async {
    await _store.delete(
      await _db,
      finder: Finder(
        filter: Filter.equals(CallModel.idSerializedName, callId),
      ),
    );
  }

  @override
  Future<List<CallModel>> getAllCalls() async {
    final records = await _store.find(
      await _db,
      finder: Finder(sortOrders: [SortOrder(CallModel.dateSerializedName, false)]),
    );

    return records.map((e) => CallModel.fromJson(e.value)).toList();
  }

  @override
  Future<CallModel?> getOneCall(String callId) async {
    final records = await _store.find(
      await _db,
      finder: Finder(filter: Filter.equals(CallModel.idSerializedName, callId)),
    );

    if (records.isEmpty) {
      return null;
    }

    final callJson = records.first.value;
    return CallModel.fromJson(callJson);
  }

  @override
  Future<List<CallModel>> getCallsFromUserId(String userId) async {
    final records = await _store.find(
      await _db,
      finder: Finder(
        sortOrders: [SortOrder(CallModel.dateSerializedName, false)],
        filter: Filter.equals(
          "${CallModel.userSerializedName}.${UserModel.walletAddressSerializedName}",
          userId,
        ),
      ),
    );

    return records.map((e) => CallModel.fromJson(e.value)).toList();
  }

  @override
  Future<Stream<List<CallModel>>> getCallsStream() async {
    final query = _store.query(
      finder: Finder(sortOrders: [SortOrder(CallModel.dateSerializedName, false)]),
    );

    return query.onSnapshots(await _db).transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(data.map((e) => CallModel.fromJson(e.value)).toList());
        },
      ),
    );
  }

  @override
  Future<void> updateCall(CallModel call) async {
    await _store.update(
      await _db,
      call.toJson(),
      finder: Finder(
        filter: Filter.equals(CallModel.idSerializedName, call.id),
      ),
    );
  }
}
