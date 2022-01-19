import 'package:flutter/material.dart';
import 'package:my_contacts_app/model/contact.dart';
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
      body: StreamBuilder<ContactDetailState>(
        stream: _contactDetailBloc.state,
        builder: (context, snapshot) {
          final state = snapshot.data;
          return Loader(
            isLoading: state is Loading,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(widget.contact.name ?? ""),
                const SizedBox(
                  height: 10,
                ),
                LocationItemView(
                  widget.contact.city ?? "",
                  widget.contact.state ?? "",
                ),
                const Divider(
                  height: 1,
                  color: Colors.black,
                ),
                PhoneItemView(widget.contact.phoneNumber ?? ""),
                EmailItemView(widget.contact.email ?? ""),
                DeleteContactButton(
                  onDelete: deleteContact,
                  contactId: widget.contact.id ?? 0,
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void deleteContact(int id) {
    _contactDetailBloc.deleteContact(id);
  }
}

class DeleteContactButton extends StatelessWidget {
  final Function onDelete;
  final int contactId;

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
    return Text("$city $state");
  }
}

class PhoneItemView extends StatelessWidget {
  final String phoneNumber;

  const PhoneItemView(this.phoneNumber, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.phone),
        Text(phoneNumber),
      ],
    );
  }
}

class EmailItemView extends StatelessWidget {
  final String email;

  const EmailItemView(this.email, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.email),
        Text(email),
      ],
    );
  }
}
