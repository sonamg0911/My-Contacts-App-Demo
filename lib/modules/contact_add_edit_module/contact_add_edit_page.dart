import 'package:flutter/material.dart';
import 'package:my_contacts_app/model/contact.dart';
import 'package:my_contacts_app/modules/contact_add_edit_module/contact_add_edit_bloc.dart';
import 'package:my_contacts_app/modules/contact_add_edit_module/contact_add_edit_state.dart';
import 'package:my_contacts_app/resources/strings.dart';
import 'package:my_contacts_app/widgets/loader.dart';

class ContactAddEditPage extends StatefulWidget {
  final Contact? contact;

  const ContactAddEditPage({this.contact, Key? key}) : super(key: key);

  @override
  _ContactAddEditPageState createState() => _ContactAddEditPageState();
}

class _ContactAddEditPageState extends State<ContactAddEditPage> {
  final ContactAddEditBloc _contactAddEditBloc = ContactAddEditBloc();

  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    //disposing the controller when state is no more present
    _contactAddEditBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.contactDetail),
      ),
      body: StreamBuilder<ContactAddEditState>(
        stream: _contactAddEditBloc.state,
        builder: (context, snapshot) {
          final state = snapshot.data;
          return Loader(
            isLoading: state is Loading,
            child: Column(
              children: [
                EditContactInfoView(
                  "Name",
                  infoController: nameController,
                ),
                EditContactInfoView(
                  "City",
                  infoController: cityController,
                ),
                EditContactInfoView(
                  "State",
                  infoController: stateController,
                ),
                EditContactInfoView(
                  "Phone Number",
                  infoController: phoneNumberController,
                ),
                EditContactInfoView(
                  "Email ID",
                  infoController: emailController,
                ),
                TextButton(
                  child: widget.contact == null ? Text(Strings.addContact) : Text(Strings.updateContact),
                  onPressed: () {
                    final contact = getContact();
                    widget.contact == null
                        ? _contactAddEditBloc.addContact(contact)
                        : _contactAddEditBloc.editContact(contact);
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Contact getContact() {
    final contact = Contact(
      name: nameController.text,
      email: emailController.text,
      state: stateController.text,
      city: cityController.text,
      phoneNumber: phoneNumberController.text,
    );
    return contact;
  }
}

class EditContactInfoView extends StatelessWidget {
  final String infoName;
  final TextEditingController infoController;

  const EditContactInfoView(
    this.infoName, {
    required this.infoController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: infoName,
      ),
      controller: infoController,
    );
  }
}
