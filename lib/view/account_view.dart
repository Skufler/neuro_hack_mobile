import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neuro_hack/model/user.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../constants.dart';

class AccountView extends StatefulWidget {
  final AccountViewState _state;

  AccountView(User user) : _state = AccountViewState(user);

  @override
  AccountViewState createState() => _state;
}

class AccountViewState extends State<AccountView> {
  User _user;

  AccountViewState(this._user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                  // 'https://images.pexels.com/photos/206359/pexels-photo-206359.jpeg?cs=srgb&dl=beautiful-calm-clouds-206359.jpg&fm=jpg'),
                  'https://pp.userapi.com/c858432/v858432863/4a71/E6nxNrY-kYU.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(children: [
            Expanded(
              flex: 3,
              child: Center(
                child: ClipOval(
                  child: Image.memory(
                    base64Decode(_user.avatar),
                    fit: BoxFit.fill,
                    height: 175,
                    width: 175,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  Text(_user.name + " " + _user.surname,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat')),
                  Text(_user.email,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Montserrat'))
                ],
              ),
            )
          ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Constants.primary,
        child: Icon(
          Icons.edit,
        ),
      ),
    );
  }
}
