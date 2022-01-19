import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_contacts_app/model/contact.dart';
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.myContacts),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _contactListBloc.state,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const NoContactsView();
          } else if (snapshot.hasError) {
            showErrorMessage(Strings.somethingWentWrong);
          } else if (snapshot.hasData) {
            //do conversion from snapshot to Contact list
            //_contactList = state.contacts;
          }
          return Loader(
            isLoading: !snapshot.hasData,
            loadingMessage: Strings.loadingContacts,
            child: ListView.separated(
                itemCount: _contactList.length,
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 2,
                    color: Colors.black,
                  );
                },
                itemBuilder: (context, index) {
                  return ContactListItem(_contactList.elementAt(index));
                }),
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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.phone),
          Text(contact.name ?? ""),
        ],
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
        style: TextStyle(fontSize: Theme.of(context).textTheme.headline4?.fontSize),
      ),
    );
  }
}
