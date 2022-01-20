import 'package:flutter/material.dart';
import 'package:my_contacts_app/model/contact.dart';
import 'package:my_contacts_app/modules/contact_add_edit_module/contact_add_edit_page.dart';
import 'package:my_contacts_app/modules/contact_detail_module/contact_detail_bloc.dart';
import 'package:my_contacts_app/modules/contact_detail_module/contact_detail_state.dart';
import 'package:my_contacts_app/resources/strings.dart';
import 'package:my_contacts_app/widgets/loader.dart';

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
          return Loader(
            isLoading: state is Loading,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "${widget.contact.firstName} ${widget.contact.lastName}",
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.headline4?.fontSize,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                LocationItemView(
                  widget.contact.city ?? "",
                  widget.contact.state ?? "",
                ),
                ItemView(widget.contact.phoneNumber ?? "", Icons.phone),
                ItemView(widget.contact.email ?? "", Icons.email),
                DeleteContactButton(
                  onDelete: deleteContact,
                  contactId: widget.contact.id ?? "",
                )
              ],
            ),
          );
        },
      ),
    );
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
      onPressed: onDelete(contactId),
      child: const Text(Strings.deleteContact),
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
      style: TextStyle(
        fontSize: Theme.of(context).textTheme.headline1?.fontSize,
        color: Colors.blueGrey,
      ),
    );
  }
}

class ItemView extends StatelessWidget {
  final String itemName;
  final IconData iconData;

  const ItemView(this.itemName, this.iconData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(
              iconData,
              size: 20,
            ),
            Text(
              itemName,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headline5?.fontSize,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
