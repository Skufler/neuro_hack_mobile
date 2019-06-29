import 'package:flutter/material.dart';
import 'package:neuro_hack/model/recommendation.dart';
import 'package:neuro_hack/presenter/main_list_view_contract.dart';
import 'package:neuro_hack/presenter/main_list_view_presenter.dart';

import 'dart:convert';

import 'account_view.dart';
import 'contact_view.dart';

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
  bool _isExpanded = false;
  Recommendation recommendation;

  RecommendationTileState(this.recommendation);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Container(
        child: Column(
          children: <Widget>[
            Image.memory(
              base64Decode(recommendation.picture),
              width: double.infinity,
              fit: BoxFit.fill,
              height: 200,
            ),
            Container(
                margin: EdgeInsets.all(20),
                child: Text(
                  recommendation.text,
                  maxLines: this._isExpanded ? null : 3,
                )),
            Divider(
              height: 20,
              color: Colors.black,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  this._isExpanded = !this._isExpanded;
                });
              },
              child: Container(
                child: Text('Expand'),
                padding: EdgeInsets.only(bottom: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MainViewState extends State<MainView>
    implements RecommendationListViewContract {
  int _currentIndex = 1;
  bool _isLoading = false;

  RecommendationListViewPresenter _presenter;
  List<Recommendation> _recommendations = [];

  MainViewState() {
    _presenter = new RecommendationListViewPresenter(this);
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
      AccountView(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Main'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.group), title: Text('Контакты')),
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
  }

  Widget _recommendationsWidget() {
    return Column(
      children: <Widget>[
        Flexible(
          child: ListView.builder(
              itemCount: _recommendations.length,
              itemBuilder: (BuildContext context, int index) {
                final Recommendation recommendation = _recommendations[index];
                return RecommendationTile(recommendation);
              }),
        )
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
    // TODO: implement onFetchFailure
  }
}
