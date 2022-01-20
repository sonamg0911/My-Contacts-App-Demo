abstract class ContactAddEditState {}

class Initial extends ContactAddEditState {}

class Loading extends ContactAddEditState {}

class Failed extends ContactAddEditState {
  final String message;

  Failed(this.message);
}

class ContactAddEditSuccess extends ContactAddEditState {}
