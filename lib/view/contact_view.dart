import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neuro_hack/model/contact.dart';
import 'package:neuro_hack/presenter/contact_list_view_contract.dart';
import 'package:neuro_hack/presenter/contact_list_view_presenter.dart';

import 'evaluate_view.dart';

class ContactTile extends StatefulWidget {
  final ContactTileState _state;

  ContactTile(Contact contact) : _state = ContactTileState(contact);

  @override
  ContactTileState createState() => _state;
}

class ContactTileState extends State<ContactTile> {
  Contact contact;

  ContactTileState(this.contact);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
          radius: 30.0,
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: Image.memory(base64Decode(contact.avatar)),
          )),
      title: Text(contact.name),
      subtitle: Text(contact.surname),
    );
  }
}

class ContactsView extends StatefulWidget {
  @override
  ContactsViewState createState() => ContactsViewState();
}

class ContactsViewState extends State<ContactsView>
    implements ContactListViewContract {
  List<Contact> _contacts = [];
  ContactListViewPresenter _presenter;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _presenter.loadContacts();
    this._isLoading = true;
  }

  ContactsViewState() {
    _presenter = new ContactListViewPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: <Widget>[
                  Flexible(
                      child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EvaluateView()));
                    },
                    child: ListView.separated(
                        itemCount: _contacts.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            height: 20,
                            color: Colors.black38,
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          final Contact contact = _contacts[index];
                          return ContactTile(contact);
                        }),
                  )),
                ],
              ));
  }

  @override
  void onContactsFetchComplete(List<Contact> items) {
    setState(() {
      this._isLoading = false;
      this._contacts = items;
    });
  }

  @override
  void onContactsFetchFailure() {
    // TODO: implement onContactsFetchFailure
  }
}
