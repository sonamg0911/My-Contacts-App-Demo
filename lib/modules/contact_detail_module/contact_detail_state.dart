abstract class ContactDetailState {}

class Loading extends ContactDetailState {}

class Failed extends ContactDetailState {
  final String message;

  Failed(this.message);
}

class ContactDeleteSuccess extends ContactDetailState {}
