import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neuro_hack/model/contact.dart';
import 'package:neuro_hack/presenter/contact_view_contract.dart';
import 'package:neuro_hack/presenter/contact_view_presenter.dart';

import 'evaluate_view.dart';

class ContactsView extends StatefulWidget {
  @override
  ContactsViewState createState() => ContactsViewState();
}

class ContactsViewState extends State<ContactsView>
    implements ContactViewContract {
  bool _isLoading = false;
  List<Contact> _contacts = [];
  ContactViewPresenter _presenter;

  @override
  void initState() {
    super.initState();
    _presenter.loadContacts(1);
    _isLoading = true;
  }

  ContactsViewState() {
    _presenter = new ContactViewPresenter(this);
  }

  Widget _buildTile(BuildContext context, Contact contact) {
    return ListTile(
      onTap: () async {
        var remove = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => EvaluateView(contact)));
        setState(() {
          _contacts.remove(remove);
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: <Widget>[
                  _contacts.length > 0
                      ? Flexible(
                          child: ListView.separated(
                              itemCount: _contacts.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Divider(
                                  height: 20,
                                  color: Colors.black38,
                                );
                              },
                              itemBuilder: (BuildContext context, int index) {
                                final Contact contact = _contacts[index];
                                return _buildTile(context, contact);
                              }),
                        )
                      : Expanded(
                          child: Center(
                          child: Text(
                            'List is empty',
                            style: TextStyle(fontSize: 18),
                          ),
                        ))
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
}
