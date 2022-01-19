import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_contacts_app/database/database_manager.dart';
import 'package:my_contacts_app/modules/shared/bloc.dart';
import 'package:my_contacts_app/repository/data_repository.dart';

class ContactListBloc extends Bloc {
  final _dataRepository = DataRepository();

  Stream<QuerySnapshot> get state =>
      _dataRepository.databaseManager.collection(DataBaseManager.collectionName).snapshots();

  @override
  void dispose() {}
}
