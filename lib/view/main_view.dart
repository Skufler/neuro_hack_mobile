import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:neuro_hack/model/recommendation.dart';
import 'package:neuro_hack/model/user.dart';
import 'package:neuro_hack/presenter/main_view_contract.dart';
import 'package:neuro_hack/presenter/main_view_presenter.dart';

import 'dart:convert';

import '../constants.dart';
import 'account_view.dart';
import 'contact_view.dart';

class ExpandableText extends StatefulWidget {
  ExpandableText(this.text);

  final String text;

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
  final RecommendationTileState _state;

  RecommendationTile(Recommendation recommendation)
      : _state = RecommendationTileState(recommendation);

  @override
  RecommendationTileState createState() => _state;
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
      AccountView(User(
          uid: 1,
          name: 'Валерий',
          surname: 'Жмышенко',
          email: 'matviei.skufin@gmail.com',
          age: 56,
          avatar: Constants.avatar)),
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
    _presenter.loadRecommendations(1);
    _isLoading = true;

    /* Timer.periodic(Duration(seconds: 10), (_timer) {
      _presenter.loadRecommendations(1);
    });*/
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
                return RecommendationTile(recommendation);
              }),
        ),
      ],
    );
  }

  @override
  void onRecommendationsFetchComplete(List<Recommendation> items) {
    setState(() {
      _recommendations = items;
      _isLoading = false;
    });
  }

  @override
  void onRecommendationsFetchFailure() {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text('Couldn\'t get info from server'),
    ));
  }
}
