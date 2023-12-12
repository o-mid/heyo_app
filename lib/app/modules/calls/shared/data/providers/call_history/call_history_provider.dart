import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_history_model/call_history_model.dart';
import 'package:heyo/app/modules/calls/shared/data/providers/call_history/call_history_abstract_provider.dart';
import 'package:heyo/app/modules/shared/providers/database/app_database.dart';
import 'package:sembast/sembast.dart';

class CallHistoryProvider implements CallHistoryAbstractProvider {
  CallHistoryProvider({required this.appDatabaseProvider});

  final AppDatabaseProvider appDatabaseProvider;
  static const String callHistoryStoreName = 'call_history';

  final _store = intMapStoreFactory.store(callHistoryStoreName);

  Future<Database> get _db async => await appDatabaseProvider.database;

  @override
  Future<void> insert(CallHistoryModel call) async {
    try {
      await _store.add(await _db, call.toJson());
    } catch (e) {
      debugPrint(e.toString());
    }
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
        filter: Filter.equals('id', callId),
      ),
    );
  }

  @override
  Future<List<CallHistoryModel>> getAllCalls() async {
    final records = await _store.find(
      await _db,
      finder: Finder(
        sortOrders: [SortOrder('startDate', false)],
      ),
    );

    return records.map((e) => CallHistoryModel.fromJson(e.value)).toList();
  }

  @override
  Future<CallHistoryModel?> getOneCall(String callId) async {
    final records = await _store.find(
      await _db,
      finder: Finder(filter: Filter.equals('callId', callId)),
    );

    if (records.isEmpty) {
      return null;
    }

    final callJson = records.first.value;
    return CallHistoryModel.fromJson(callJson);
  }

  @override
  Future<List<CallHistoryModel>> getCallsFromUserId(String userId) async {
    //* because sembast does not support nested query
    //* we need to use custom filter
    final customFilter = Filter.custom((record) {
      final participants = (record['participants']! as List)
          .map((participant) => (participant as Map)['coreId'] as String);
      return participants.contains(userId);
    });

    final records = await _store.find(
      await _db,
      finder: Finder(
        sortOrders: [SortOrder('startDate', false)],
        filter: customFilter,
      ),
    );

    return records.map((e) => CallHistoryModel.fromJson(e.value)).toList();
  }

  @override
  Future<Stream<List<CallHistoryModel>>> getCallsStream() async {
    final query = _store.query(
      finder: Finder(sortOrders: [SortOrder('startDate', false)]),
    );

    return query.onSnapshots(await _db).transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(
              data.map((e) => CallHistoryModel.fromJson(e.value)).toList());
        },
      ),
    );
  }

  @override
  Future<void> updateCall(CallHistoryModel call) async {
    try {
      await _store.update(
        await _db,
        call.toJson(),
        finder: Finder(
          filter: Filter.equals('callId', call.callId),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
