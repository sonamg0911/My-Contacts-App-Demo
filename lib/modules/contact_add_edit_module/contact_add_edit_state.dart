abstract class ContactAddEditState {}

class Loading extends ContactAddEditState {}

class Failed extends ContactAddEditState {
  final String message;

  Failed(this.message);
}

class ContactAddEditSuccess extends ContactAddEditState {}
