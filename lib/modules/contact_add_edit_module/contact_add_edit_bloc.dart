import 'package:my_contacts_app/model/contact.dart';
import 'package:my_contacts_app/modules/contact_add_edit_module/contact_add_edit_state.dart';
import 'package:my_contacts_app/modules/shared/bloc.dart';
import 'package:my_contacts_app/repository/data_repository.dart';
import 'package:my_contacts_app/resources/strings.dart';
import 'package:rxdart/rxdart.dart';

class ContactAddEditBloc extends Bloc {
  final _dataRepository = DataRepository();

  final _state = BehaviorSubject<ContactAddEditState>.seeded(Loading());

  Stream<ContactAddEditState> get state => _state.stream;

  Future<void> editContact(Contact contact) async {
    try {
      await _dataRepository.editContact(contact);
      _state.add(ContactAddEditSuccess());
    } on Exception {
      _state.add(Failed(Strings.contactsFetchingFailedMessage));
    }
  }

  Future<void> addContact(Contact contact) async {
    try {
      await _dataRepository.addContact(contact);
      _state.add(ContactAddEditSuccess());
    } on Exception {
      _state.add(Failed(Strings.contactsFetchingFailedMessage));
    }
  }

  @override
  void dispose() {
    _state.close();
  }
}
