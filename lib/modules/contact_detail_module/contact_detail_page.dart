import 'package:flutter/material.dart';
import 'package:my_contacts_app/model/contact.dart';
import 'package:my_contacts_app/modules/contact_add_edit_module/contact_add_edit_page.dart';
import 'package:my_contacts_app/modules/contact_detail_module/contact_detail_bloc.dart';
import 'package:my_contacts_app/modules/contact_detail_module/contact_detail_state.dart';
import 'package:my_contacts_app/resources/strings.dart';
import 'package:my_contacts_app/utils/helpers.dart';
import 'package:my_contacts_app/widgets/loader.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDetailPage extends StatefulWidget {
  final Contact contact;

  const ContactDetailPage(this.contact, {Key? key}) : super(key: key);

  @override
  _ContactDetailPageState createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends State<ContactDetailPage> {
  final ContactDetailBloc _contactDetailBloc = ContactDetailBloc();

  @override
  void dispose() {
    //disposing the controller when state is no more present
    _contactDetailBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.contactDetail),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactAddEditPage(
                contact: widget.contact,
              ),
            ),
          );
        },
      ),
      body: StreamBuilder<ContactDetailState>(
        stream: _contactDetailBloc.state,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state is ContactDeleteSuccess) {
            Navigator.pop(context);
          } else if (state is Failed) {
            WidgetsBinding.instance!.addPostFrameCallback(
              (_) => showErrorMessage(state.message),
            );
          }
          return Loader(
            isLoading: state is Loading,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${widget.contact.firstName} ${widget.contact.lastName}",
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  LocationItemView(
                    widget.contact.city ?? "",
                    widget.contact.state ?? "",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ItemView(widget.contact.phoneNumber ?? "", Icons.phone, _makePhoneCall),
                  const SizedBox(
                    height: 20,
                  ),
                  ItemView(widget.contact.email ?? "", Icons.email, _openEmailApp),
                  const SizedBox(
                    height: 20,
                  ),
                  DeleteContactButton(
                    onDelete: deleteContact,
                    contactId: widget.contact.id ?? "",
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  Future<void> _openEmailApp(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launch(launchUri.toString());
  }

  void showErrorMessage(String message) {
    Alerts.showSnackBar(context, message);
  }

  void deleteContact(String id) {
    _contactDetailBloc.deleteContact(id);
  }

  void editContact(Contact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactAddEditPage(
          contact: contact,
        ),
      ),
    );
  }
}

class DeleteContactButton extends StatelessWidget {
  final Function onDelete;
  final String contactId;

  const DeleteContactButton({
    required this.onDelete,
    required this.contactId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onDelete(contactId),
      child: const Text(
        Strings.deleteContact,
        style: TextStyle(fontSize: 22),
      ),
    );
  }
}

class LocationItemView extends StatelessWidget {
  final String city;
  final String state;

  const LocationItemView(this.city, this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "$city $state",
      style: const TextStyle(
        fontSize: 18,
        color: Colors.blueGrey,
      ),
    );
  }
}

class ItemView extends StatelessWidget {
  final String itemName;
  final IconData iconData;
  final Function onItemClick;

  const ItemView(this.itemName, this.iconData, this.onItemClick, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onItemClick(itemName),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                iconData,
                size: 20,
              ),
              const SizedBox(
                width: 30,
              ),
              Text(
                itemName,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
