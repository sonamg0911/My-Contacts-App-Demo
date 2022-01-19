import 'dart:async';

import 'package:my_contacts_app/database/database_manager.dart';
import 'package:my_contacts_app/model/contact.dart';

class DataRepository {
  final databaseManager = DataBaseManager.fireStoreDataBase;

  Future<void> addContact(Contact contact) async {}

  Future<void> editContact(Contact contact) async {}

  Future<void> deleteContact(int id) async {}
}
