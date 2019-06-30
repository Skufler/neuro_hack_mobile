import 'package:flutter/material.dart';
import 'package:neuro_hack/model/contact.dart';
import 'package:neuro_hack/model/eval_data.dart';
import 'package:neuro_hack/presenter/contact_view_contract.dart';
import 'package:neuro_hack/presenter/contact_view_presenter.dart';

var _params = {
  'partnership': 0,
  'joint': 0,
  'responsibility': 0,
  'kindness': 0,
  'trust': 0,
  'anger': 0,
  'irritability': 0,
  'compliance': 0,
  'sociopathy': 0,
  'isolation': 0,
};

class EvaluateWidget extends StatefulWidget {
  final EvaluateWidgetState _state;

  EvaluateWidget(String description)
      : _state = EvaluateWidgetState(description);

  @override
  EvaluateWidgetState createState() => _state;
}

class EvaluateWidgetState extends State<EvaluateWidget> {
  String description;
  double _progress = 5;

  EvaluateWidgetState(this.description);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(description[0].toUpperCase() + description.substring(1)),
          Slider(
            min: 1,
            max: 10,
            divisions: 10,
            value: _progress,
            onChanged: (value) {
              setState(() {
                _progress = value;
                _params[description] = value.toInt();
              });
            },
          ),
          Text(_progress.toInt().toString())
        ],
      ),
    );
  }
}

class EvaluateView extends StatefulWidget {
  final EvaluateViewState _state;

  EvaluateView(Contact contact) : _state = EvaluateViewState(contact);

  @override
  EvaluateViewState createState() => _state;
}

class EvaluateViewState extends State<EvaluateView>
    implements ContactViewContract {
  Contact _contact;
  ContactViewPresenter _presenter;

  EvaluateViewState(this._contact);

  @override
  void initState() {
    super.initState();

    _presenter = new ContactViewPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Flexible(
            child: ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      EvaluateWidget(_params.keys.elementAt(index))
                    ],
                  );
                })),
        OutlineButton(
          onPressed: () {
            _presenter.sendEvalData(EvalData(
                evaluator: 1,
                uid: _contact.uid,
                anger: _params['anger'],
                compliance: _params['compliance'],
                irritability: _params['irritability'],
                isolation: _params['isolation'],
                joint: _params['joint'],
                kindness: _params['kindness'],
                partnership: _params['partnership'],
                responsibility: _params['responsibility'],
                sociopathy: _params['sociopathy'],
                trust: _params['trust'],
                date: DateTime.now().toString().substring(0, 10)));
          },
        ),
      ],
    ));
  }

  @override
  void onContactsFetchComplete(List<Contact> items) {
    // TODO: implement onContactsFetchComplete
  }

  @override
  void onContactsFetchFailure() {
    // TODO: implement onContactsFetchFailure
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
