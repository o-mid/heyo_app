import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:heyo/modules/features/contact/data/models/contact_dto/contact_dto.dart';
import 'package:heyo/modules/features/contact/domain/contact_repo.dart';
import 'package:heyo/modules/features/contact/domain/models/contact_model/contact_model.dart';
import 'package:sembast/sembast.dart';

class LocalContactRepo implements ContactRepo {
  LocalContactRepo({required this.appDatabaseProvider});
  final AppDatabaseProvider appDatabaseProvider;
  static const String contactsStoreName = 'contacts';

  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of
  // which are Contact objects converted to Map
  final _contactsStore = intMapStoreFactory.store(contactsStoreName);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => appDatabaseProvider.database;

  @override
  Future<List<ContactModel>> getContacts() async {
    // Finder object can also sort data.
    final finder = Finder(
      sortOrders: [
        SortOrder('username'),
      ],
    );

    final records = await _contactsStore.find(
      await _db,
      finder: finder,
    );

    final contacts = records.map(
      (e) {
        // Convert RecordSnapshot to ContactDTO
        final contactDTO = ContactDTO.fromJson(e.value);
        // Convert ContactDTO to ContactModel
        return contactDTO.toContactModel();
      },
    ).toList();

    return contacts;
  }

  @override
  Future<void> addContact(ContactModel contact) async {
    final contactDTO = contact.toContactDTO();
    await _contactsStore.add(
      await _db,
      contactDTO.toJson(),
    );
  }

  @override
  Future<List<ContactModel>> search(String query) async {
    final contacts = await getContacts();
    return contacts
        .where(
          (element) =>
              element.name.toLowerCase().contains(query.toLowerCase()) ||
              element.coreId.startsWith(query),
        )
        .toList();
  }

  @override
  Future<void> deleteUserContact(ContactModel contact) async {
    final contactDTO = contact.toContactDTO();
    final finder = Finder(filter: Filter.equals('coreId', contactDTO.coreId));
    await _contactsStore.delete(
      await _db,
      finder: finder,
    );
  }

  @override
  Future<void> deleteContactById(String contactCoreId) async {
    final finder = Finder(filter: Filter.equals('coreId', contactCoreId));
    await _contactsStore.delete(
      await _db,
      finder: finder,
    );
  }

  @override
  Future<void> updateUserContact(ContactModel contact) async {
    try {
      final contactDTO = contact.toContactDTO();
      final finder = Finder(filter: Filter.equals('coreId', contactDTO.coreId));
      await _contactsStore.update(
        await _db,
        contactDTO.toJson(),
        finder: finder,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<ContactModel?> getContactById(String contactCoreId) async {
    final records = await _contactsStore.find(
      await _db,
      finder: Finder(filter: Filter.equals('coreId', contactCoreId)),
    );

    if (records.isEmpty) {
      return null;
    }

    final userJson = records.first.value;
    return ContactModel.fromJson(userJson);
  }

  //@override
  //Future<List<ContactModel>> getBlockedContacts() {
  //  return cacheContractor.getBlockedContacts();
  //}

  @override
  Future<Stream<List<ContactModel>>> getContactsStream() async {
    final query = _contactsStore.query(
      finder: Finder(sortOrders: [SortOrder('username', false)]),
    );

    return query.onSnapshots(await _db).transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(
            data.map((e) {
              // Convert RecordSnapshot to ContactDTO
              final contactDTO = ContactDTO.fromJson(e.value);
              // Convert ContactDTO to ContactModel
              return contactDTO.toContactModel();
            }).toList(),
          );
        },
      ),
    );
  }
}
