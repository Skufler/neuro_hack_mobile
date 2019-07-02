import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neuro_hack/model/recommendation.dart';
import 'package:neuro_hack/presenter/main_view_contract.dart';
import 'package:neuro_hack/presenter/main_view_presenter.dart';

import '../constants.dart';
import 'account_view.dart';
import 'contact_view.dart';

class ExpandableText extends StatefulWidget {
  final String _text;

  ExpandableText(String text) : this._text = text;

  @override
  _ExpandableTextState createState() => new _ExpandableTextState(_text);
}

class _ExpandableTextState extends State<ExpandableText>
    with TickerProviderStateMixin<ExpandableText> {
  String _text;
  bool _isExpanded = false;

  _ExpandableTextState(this._text);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      AnimatedSize(
          vsync: this,
          duration: const Duration(milliseconds: 500),
          child: ConstrainedBox(
              constraints: _isExpanded
                  ? BoxConstraints()
                  : BoxConstraints(maxHeight: 50.0),
              child: Text(
                this._text,
                softWrap: true,
                overflow: TextOverflow.fade,
              ))),
      Column(children: <Widget>[
        Divider(
          height: 20,
          color: Colors.black,
        ),
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Container(
            child: Text(_isExpanded ? 'Hide' : 'Expand'),
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
  final Recommendation _recommendation;

  RecommendationTile({Recommendation recommendation})
      : this._recommendation = recommendation;

  @override
  RecommendationTileState createState() =>
      new RecommendationTileState(_recommendation);
}

class RecommendationTileState extends State<RecommendationTile> {
  Recommendation _recommendation;

  RecommendationTileState(this._recommendation);

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
              base64Decode(_recommendation.picture),
              width: double.infinity,
              alignment: Alignment.topCenter,
              fit: BoxFit.fitWidth,
              height: 250,
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: ExpandableText(_recommendation.text),
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
      AccountView(id: Constants.userId),
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

    Timer.periodic(Duration(seconds: 10), (_timer) {
      _presenter.loadRecommendations(1);
    });
    _isLoading = true;
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
