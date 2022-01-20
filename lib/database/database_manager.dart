import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseManager {
  static FirebaseFirestore fireStoreDataBase = FirebaseFirestore.instance;

  static const String collectionName = "contacts";

  static void addContact({
    String? firstName,
    String? lastName,
    String? mobileNo,
    String? email,
    String? city,
    String? state,
  }) async {
    try {
      await fireStoreDataBase.collection(collectionName).add({
        'firstName': firstName,
        'lastName': lastName,
        'city': city,
        'state': state,
        'mobileNo': mobileNo,
        'email': email,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  static void updateContact(
    String documentId, {
    String? firstName,
    String? lastName,
    String? mobileNo,
    String? email,
    String? city,
    String? state,
  }) async {
    try {
      await fireStoreDataBase.collection(collectionName).doc(documentId).update({
        'firstName': firstName,
        'lastName': lastName,
        'city': city,
        'state': state,
        'mobileNo': mobileNo,
        'email': email,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  static void deleteContact(String documentId) {
    try {
      fireStoreDataBase.collection(collectionName).doc(documentId).delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
