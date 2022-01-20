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

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    firstNameController.text = widget.contact?.firstName ?? "";
    lastNameController.text = widget.contact?.lastName ?? "";
    phoneNumberController.text = widget.contact?.phoneNumber ?? "";
    cityController.text = widget.contact?.city ?? "";
    stateController.text = widget.contact?.state ?? "";
    emailController.text = widget.contact?.email ?? "";
  }

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
        title: const Text(Strings.addContact),
      ),
      body: StreamBuilder<ContactAddEditState>(
        stream: _contactAddEditBloc.state,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state is ContactAddEditSuccess) {
            Navigator.pop(context);
          }
          return Loader(
            isLoading: state is Loading,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  EditContactInfoView(
                    "Add First Name",
                    infoController: firstNameController,
                  ),
                  EditContactInfoView(
                    "Add Last Name",
                    infoController: lastNameController,
                  ),
                  EditContactInfoView(
                    "Add City Name",
                    infoController: cityController,
                  ),
                  EditContactInfoView(
                    "Add State Name",
                    infoController: stateController,
                  ),
                  EditContactInfoView(
                    "Add Phone Number",
                    infoController: phoneNumberController,
                  ),
                  EditContactInfoView(
                    "Add Email ID",
                    infoController: emailController,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextButton(
                      child: widget.contact == null
                          ? Text(
                              Strings.addContact,
                              style: TextStyle(
                                fontSize: Theme.of(context).textTheme.headline5?.fontSize,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              Strings.updateContact,
                              style: TextStyle(
                                fontSize: Theme.of(context).textTheme.headline5?.fontSize,
                                color: Colors.white,
                              ),
                            ),
                      onPressed: () {
                        final contact = getContact();
                        widget.contact == null
                            ? _contactAddEditBloc.addContact(contact)
                            : _contactAddEditBloc.editContact(contact);
                      },
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

  Contact getContact() {
    final contact = Contact(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
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
    return Container(
      padding: EdgeInsets.all(8),
      child: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: infoName,
        ),
        controller: infoController,
      ),
    );
  }
}
