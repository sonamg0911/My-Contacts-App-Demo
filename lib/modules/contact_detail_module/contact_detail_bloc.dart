import 'package:my_contacts_app/modules/contact_detail_module/contact_detail_state.dart';
import 'package:my_contacts_app/modules/shared/bloc.dart';
import 'package:my_contacts_app/repository/data_repository.dart';
import 'package:my_contacts_app/resources/strings.dart';
import 'package:rxdart/rxdart.dart';

class ContactDetailBloc extends Bloc {
  final _dataRepository = DataRepository();

  final _state = BehaviorSubject<ContactDetailState>.seeded(Initial());

  Stream<ContactDetailState> get state => _state.stream;

  Future<void> deleteContact(String id) async {
    _state.add(Loading());
    try {
      await _dataRepository.deleteContact(id);
      _state.add(ContactDeleteSuccess());
    } on Exception {
      _state.add(Failed(Strings.contactsFetchingFailedMessage));
    }
  }

  @override
  void dispose() {
    _state.close();
  }
}
