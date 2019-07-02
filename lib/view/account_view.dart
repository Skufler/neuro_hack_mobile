import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:neuro_hack/model/user.dart';
import 'package:neuro_hack/model/user_mock.dart';

import '../constants.dart';
import '../exceptions.dart';

class AccountView extends StatefulWidget {
  final int _id;

  AccountView({int id}) : this._id = id;

  @override
  AccountViewState createState() => new AccountViewState(_id);
}

class AccountViewState extends State<AccountView> {
  int _id;
  User _user;

  AccountViewState(this._id);

  Future<User> _fetchUser(int id) async {
    http.Response response =
        await http.get(Constants.serviceURL + "user/get/" + id.toString());

    var responseBody = json.decode(response.body);
    final statusCode = response.statusCode;

    if (statusCode != 200 || responseBody == null)
      throw new FetchDataException(message: "Error ocurred");

    var user = User.fromJson(responseBody['message']);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new FutureBuilder(future: new Future(() async {
        this._user = await _fetchUser(this._id);
      }), builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.error != null) {
          SnackBar(
            content: Text('Error occurred during server request'),
          );
        }
        this._user ??= UserMock();
        return _buildProfile();
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Constants.primary,
        child: Icon(
          Icons.edit,
        ),
      ),
    );
  }

  Container _buildProfile() {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
                // 'https://images.pexels.com/photos/206359/pexels-photo-206359.jpeg?cs=srgb&dl=beautiful-calm-clouds-206359.jpg&fm=jpg'),
                'https://pp.userapi.com/c858432/v858432863/4a71/E6nxNrY-kYU.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(children: [
          Container(
            padding: EdgeInsets.only(top: 50),
            width: 150,
            child: RaisedButton(
              onPressed: () {},
              child: Text(
                'Buy premium',
                style: TextStyle(color: Colors.black),
              ),
              color: Colors.yellowAccent,
            ),
          ),
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
        ]));
  }
}
