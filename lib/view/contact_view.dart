import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neuro_hack/model/contact.dart';
import 'package:neuro_hack/presenter/contact_view_contract.dart';
import 'package:neuro_hack/presenter/contact_view_presenter.dart';

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
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EvaluateView(contact)));
      },
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
    implements ContactViewContract {
  List<Contact> _contacts = [];
  ContactViewPresenter _presenter;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _presenter.loadContacts(1);
    this._isLoading = true;

    /*Timer.periodic(Duration(seconds: 10), (_timer) {
      _presenter.loadContacts(1);
    });*/
  }

  ContactsViewState() {
    _presenter = new ContactViewPresenter(this);
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
                  ),
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
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text('Couldn\'t get info from server'),
    ));
  }

  @override
  void onEvalDataFetchComplete(String status) {
    // TODO: implement onEvalDataFetchComplete
  }

  @override
  void onEvalDataFetchFailure() {
    // TODO: implement onEvalDataFetchFailure
  }
}
