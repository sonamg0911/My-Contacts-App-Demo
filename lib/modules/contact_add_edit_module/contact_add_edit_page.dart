import 'package:flutter/material.dart';
import 'package:my_contacts_app/model/contact.dart';
import 'package:my_contacts_app/modules/contact_add_edit_module/contact_add_edit_bloc.dart';
import 'package:my_contacts_app/modules/contact_add_edit_module/contact_add_edit_state.dart';
import 'package:my_contacts_app/resources/strings.dart';
import 'package:my_contacts_app/utils/helpers.dart';
import 'package:my_contacts_app/utils/regex.dart';
import 'package:my_contacts_app/widgets/loader.dart';

class ContactAddEditPage extends StatefulWidget {
  final Contact? contact;

  const ContactAddEditPage({this.contact, Key? key}) : super(key: key);

  @override
  _ContactAddEditPageState createState() => _ContactAddEditPageState();
}

class _ContactAddEditPageState extends State<ContactAddEditPage> {
  final ContactAddEditBloc _contactAddEditBloc = ContactAddEditBloc();

  final _formKey = GlobalKey<FormState>();

  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _phoneNumberFocus = FocusNode();
  final _cityFocus = FocusNode();
  final _stateFocus = FocusNode();
  final _emailFocus = FocusNode();

  String? _firstName;
  String? _lastName;
  String? _state;
  String? _city;
  String? _phoneNumber;
  String? _email;

  @override
  void initState() {
    super.initState();
    _firstName = widget.contact?.firstName ?? "";
    _lastName = widget.contact?.lastName ?? "";
    _phoneNumber = widget.contact?.phoneNumber ?? "";
    _city = widget.contact?.city ?? "";
    _state = widget.contact?.state ?? "";
    _email = widget.contact?.email ?? "";
  }

  @override
  void dispose() {
    //disposing the controller when state is no more present
    _contactAddEditBloc.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _phoneNumberFocus.dispose();
    _emailFocus.dispose();
    _stateFocus.dispose();
    _cityFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.addContact),
      ),
      body: StreamBuilder<ContactAddEditState>(
        stream: _contactAddEditBloc.state,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state is ContactAddEditSuccess) {
            Navigator.pop(context);
          } else if (state is Failed) {
            WidgetsBinding.instance!.addPostFrameCallback(
              (_) => showErrorMessage(state.message),
            );
          }
          return Loader(
            isLoading: state is Loading,
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  getNameInfoView(
                    Strings.firstName,
                    _firstNameFocus,
                    _updateFirstName,
                    _firstName,
                    true,
                  ),
                  getNameInfoView(
                    Strings.lastName,
                    _lastNameFocus,
                    _updateLastName,
                    _lastName,
                    true,
                  ),
                  getNameInfoView(
                    Strings.city,
                    _cityFocus,
                    _updateCity,
                    _city,
                    false,
                  ),
                  getNameInfoView(
                    Strings.state,
                    _stateFocus,
                    _updateStateName,
                    _state,
                    false,
                  ),
                  getPhoneNumberInfoView(),
                  getEmailInfoView(),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      child: widget.contact == null
                          ? Text(
                              Strings.addContact,
                              style: TextStyle(
                                fontSize: Theme.of(context).textTheme.headline5?.fontSize,
                                color: Colors.black,
                              ),
                            )
                          : Text(
                              Strings.updateContact,
                              style: TextStyle(
                                fontSize: Theme.of(context).textTheme.headline5?.fontSize,
                                color: Colors.black,
                              ),
                            ),
                      onPressed: _nextEnabled()
                          ? () {
                              final contact = getContact(widget.contact?.id ?? "");
                              widget.contact == null
                                  ? _contactAddEditBloc.addContact(contact)
                                  : _contactAddEditBloc.editContact(contact);
                            }
                          : null,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getNameInfoView(
      String infoName, FocusNode focusNode, Function onChanged, String? initialValue, bool addValidation) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: infoName,
        ),
        focusNode: focusNode,
        validator: (name) => addValidation ? _validateName(name!, infoName) : null,
        onChanged: (name) => onChanged(name),
        initialValue: initialValue,
      ),
    );
  }

  Widget getPhoneNumberInfoView() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: Strings.phoneNumber,
        ),
        initialValue: _phoneNumber,
        focusNode: _phoneNumberFocus,
        onChanged: (value) {
          _updatePhoneNumber(value);
        },
        maxLength: 10,
      ),
    );
  }

  Widget getEmailInfoView() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: Strings.emailId,
        ),
        focusNode: _emailFocus,
        validator: (email) => _validateEmail(email!),
        initialValue: _email,
        onChanged: (value) {
          _updateEmail(value);
        },
      ),
    );
  }

  void _updateFirstName(String firstName) {
    setState(() => _firstName = firstName);
  }

  void _updateLastName(String lastName) {
    setState(() => _lastName = lastName);
  }

  void _updateCity(String city) {
    setState(() => _city = city);
  }

  void _updateStateName(String state) {
    setState(() => _state = state);
  }

  void _updatePhoneNumber(String phoneNumber) {
    setState(() => _phoneNumber = phoneNumber);
  }

  void _updateEmail(String email) {
    setState(() => _email = email);
  }

  String? _validateName(String name, String infoName) {
    if (name.trim().length < 3) {
      return "Invalid $infoName";
    } else {
      return null;
    }
  }

  String? _validateEmail(String email) {
    return Regex.email.hasMatch(email) ? null : "Invalid ${Strings.emailId}";
  }

  bool _nextEnabled() {
    if (!isNullOrEmpty(_firstName) &&
        !isNullOrEmpty(_lastName) &&
        !isNullOrEmpty(_phoneNumber) &&
        (_formKey.currentState != null && _formKey.currentState!.validate())) {
      return true;
    }
    return false;
  }

  bool isNullOrEmpty(String? str) {
    return str == null || str.isEmpty;
  }

  void showErrorMessage(String message) {
    Alerts.showSnackBar(context, message);
  }

  Contact getContact(String id) {
    final contact = Contact(
      id: id,
      firstName: _firstName,
      lastName: _lastName,
      email: _email,
      state: _state,
      city: _city,
      phoneNumber: _phoneNumber,
    );
    return contact;
  }
}
