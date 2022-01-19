import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseManager {
  static FirebaseFirestore fireStoreDataBase = FirebaseFirestore.instance;

  static const String collectionName = "contacts";

  void addContact(String firstName, String lastName, String mobileNo, String email) async {
    await fireStoreDataBase.collection(collectionName).add({
      'firstName': firstName,
      'lastName': lastName,
      'mobileNo': mobileNo,
      'email': email,
    });
  }

  void updateContact(String documentId, String firstName, String lastName, String mobileNo, String email) {
    try {
      fireStoreDataBase.collection(collectionName).doc(documentId).update({
        'firstName': firstName,
        'lastName': lastName,
        'mobileNo': mobileNo,
        'email': email,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void deleteContact(String documentId) {
    try {
      fireStoreDataBase.collection(collectionName).doc(documentId).delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
