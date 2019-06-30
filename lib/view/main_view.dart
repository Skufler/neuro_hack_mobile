import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:neuro_hack/model/recommendation.dart';
import 'package:neuro_hack/model/user.dart';
import 'package:neuro_hack/presenter/main_view_contract.dart';
import 'package:neuro_hack/presenter/main_view_presenter.dart';

import 'dart:convert';

import '../constants.dart';
import '../exceptions.dart';
import 'account_view.dart';
import 'contact_view.dart';

class ExpandableText extends StatefulWidget {
  final String text;

  ExpandableText(this.text);

  @override
  _ExpandableTextState createState() => new _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText>
    with TickerProviderStateMixin<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      AnimatedSize(
          vsync: this,
          duration: const Duration(milliseconds: 500),
          child: ConstrainedBox(
              constraints: isExpanded
                  ? BoxConstraints()
                  : BoxConstraints(maxHeight: 50.0),
              child: Text(
                widget.text,
                softWrap: true,
                overflow: TextOverflow.fade,
              ))),
      isExpanded
          ? Container(
              child: InkWell(
                child: Column(
                  children: <Widget>[
                    Divider(
                      height: 20,
                      color: Colors.black,
                    ),
                    Text('Hide')
                  ],
                ),
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),
            )
          : Column(children: <Widget>[
              Divider(
                height: 20,
                color: Colors.black,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Container(
                  child: Text(isExpanded ? 'Hide' : 'Expand'),
                  padding: EdgeInsets.only(bottom: 20),
                ),
              )
            ]),
    ]);
  }
}

class MainView extends StatefulWidget {
  @override
  MainViewState createState() => MainViewState();
}

class RecommendationTile extends StatefulWidget {
  final Recommendation recommendation;

  RecommendationTile({Recommendation recommendation})
      : this.recommendation = recommendation;

  @override
  RecommendationTileState createState() =>
      new RecommendationTileState(recommendation);
}

class RecommendationTileState extends State<RecommendationTile> {
  Recommendation recommendation;

  RecommendationTileState(this.recommendation);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 10,
      child: Container(
        child: Column(
          children: <Widget>[
            Image.memory(
              base64Decode(recommendation.picture),
              width: double.infinity,
              alignment: Alignment.topCenter,
              fit: BoxFit.fitWidth,
              height: 250,
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: ExpandableText(recommendation.text),
            )
          ],
        ),
      ),
    );
  }
}

class MainViewState extends State<MainView>
    implements RecommendationListContract {
  User user;
  int _currentIndex = 1;
  bool _isLoading = false;

  RecommendationListPresenter _presenter;
  List<Recommendation> _recommendations = [];

  MainViewState() {
    _presenter = new RecommendationListPresenter(this);
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      ContactsView(),
      _recommendationsWidget(),
      AccountView(user),
    ];

    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.group), title: Text('Оценить')),
            BottomNavigationBarItem(
                icon: Icon(Icons.announcement), title: Text('Рекомендации')),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_box), title: Text('Аккаунт')),
          ]),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchUser(1).then((user) => this.user = user);

    Timer.periodic(Duration(seconds: 10), (_timer) {
      _presenter.loadRecommendations(1);
    });
    _isLoading = true;
  }

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

  Widget _recommendationsWidget() {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: _recommendations.length,
              itemBuilder: (BuildContext context, int index) {
                final Recommendation recommendation = _recommendations[index];
                return RecommendationTile(recommendation: recommendation);
              }),
        ),
      ],
    );
  }

  @override
  void onRecommendationsFetchComplete(List<Recommendation> items) {
    setState(() {
      _isLoading = false;
      _recommendations = items;
    });
  }

  @override
  void onRecommendationsFetchFailure() {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text('Couldn\'t get info from server'),
    ));
  }
}
