import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_contacts_app/model/contact.dart';
import 'package:my_contacts_app/modules/contact_add_edit_module/contact_add_edit_page.dart';
import 'package:my_contacts_app/modules/contact_detail_module/contact_detail_page.dart';
import 'package:my_contacts_app/modules/contact_list_module/contact_list_bloc.dart';
import 'package:my_contacts_app/resources/strings.dart';
import 'package:my_contacts_app/utils/helpers.dart';
import 'package:my_contacts_app/widgets/loader.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage({Key? key}) : super(key: key);

  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  final ContactListBloc _contactListBloc = ContactListBloc();

  var _contactList = [];

  @override
  void dispose() {
    //disposing the controller when state is no more present
    _contactListBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.myContacts),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ContactAddEditPage(),
            ),
          ).then((value) {
            setState(() {});
          });
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _contactListBloc.state,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            WidgetsBinding.instance!.addPostFrameCallback(
              (_) => showErrorMessage(Strings.somethingWentWrong),
            );
          } else if (snapshot.hasData) {
            var dataSize = snapshot.data?.docs.length ?? 0;
            if (dataSize > 0) {
              _contactList.clear();
              snapshot.data?.docs.forEach((document) {
                var contact = Contact(
                  id: document.id,
                  firstName: document.get('firstName'),
                  lastName: document.get('lastName'),
                  email: document.get('email'),
                  state: document.get('state'),
                  city: document.get('city'),
                  phoneNumber: document.get('mobileNo'),
                );
                _contactList.add(contact);
              });
            } else {
              return const NoContactsView();
            }
          }
          return Loader(
            isLoading: !snapshot.hasData,
            loadingMessage: Strings.loadingContacts,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: ListView.separated(
                  itemCount: _contactList.length,
                  separatorBuilder: (_, __) => const Divider(height: 0.5),
                  itemBuilder: (context, index) {
                    return ContactListItem(_contactList.elementAt(index));
                  }),
            ),
          );
        },
      ),
    );
  }

  void showErrorMessage(String message) {
    Alerts.showSnackBar(context, message);
  }
}

class ContactListItem extends StatelessWidget {
  final Contact contact;

  const ContactListItem(this.contact, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContactDetailPage(
              contact,
            ),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${contact.firstName} ${contact.lastName}",
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.headline5?.fontSize,
                      fontStyle: FontStyle.italic,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    contact.phoneNumber ?? "",
                    style: TextStyle(fontSize: Theme.of(context).textTheme.headline6?.fontSize),
                  ),
                ],
              ),
              Text(
                "${contact.city}",
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headline6?.fontSize,
                  color: Colors.blueGrey,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NoContactsView extends StatelessWidget {
  const NoContactsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Text(
        Strings.noContacts,
        style: TextStyle(fontSize: Theme.of(context).textTheme.headline6?.fontSize),
      ),
    );
  }
}
