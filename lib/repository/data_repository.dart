import 'dart:async';

import 'package:my_contacts_app/database/database_manager.dart';
import 'package:my_contacts_app/model/contact.dart';

class DataRepository {
  final databaseManager = DataBaseManager.fireStoreDataBase;

  Future<void> addContact(Contact contact) async {
    DataBaseManager.addContact(
      firstName: contact.firstName,
      lastName: contact.lastName,
      email: contact.email,
      mobileNo: contact.phoneNumber,
      city: contact.city,
      state: contact.state,
    );
  }

  Future<void> editContact(Contact contact) async {
    DataBaseManager.updateContact(
      contact.id ?? "",
      firstName: contact.firstName,
      lastName: contact.lastName,
      email: contact.email,
      mobileNo: contact.phoneNumber,
      city: contact.city,
      state: contact.state,
    );
  }

  Future<void> deleteContact(String id) async {
    DataBaseManager.deleteContact(id);
  }
}
