import 'package:flutter/material.dart';
import 'package:neuro_hack/model/contact.dart';
import 'package:neuro_hack/model/eval_data.dart';
import 'package:neuro_hack/presenter/eval_send_view_contract.dart';
import 'package:neuro_hack/presenter/eval_send_view_presenter.dart';

var _params = {
  'partnership': 5,
  'joint': 5,
  'responsibility': 5,
  'kindness': 5,
  'trust': 5,
  'anger': 5,
  'irritability': 5,
  'compliance': 5,
  'sociopathy': 5,
  'isolation': 5,
};

class EvaluateWidget extends StatefulWidget {
  final String _description;

  EvaluateWidget(String description) : this._description = description;

  @override
  EvaluateWidgetState createState() => new EvaluateWidgetState(_description);
}

class EvaluateWidgetState extends State<EvaluateWidget> {
  String description;
  double _progress = 5;

  EvaluateWidgetState(this.description);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Text(
                  description[0].toUpperCase() + description.substring(1),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  _progress.toInt().toString(),
                ),
              )
            ],
          ),
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
        ],
      ),
    );
  }
}

class EvaluateView extends StatefulWidget {
  final Contact _contact;

  EvaluateView(Contact contact) : this._contact = contact;

  @override
  EvaluateViewState createState() => new EvaluateViewState(_contact);
}

class EvaluateViewState extends State<EvaluateView>
    implements EvalSendViewContract {
  Contact _contact;
  EvalSendViewPresenter _evalPresenter;

  EvaluateViewState(this._contact);

  @override
  void initState() {
    super.initState();

    _evalPresenter = new EvalSendViewPresenter(this);
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
        RaisedButton(
          color: Colors.green,
          child: Text(
            'Send',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            _evalPresenter.sendEvalData(EvalData(
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
  void onEvalDataFetchComplete(String status) {
    if (status == "Ok") {
      Navigator.pop(context, _contact);
    }
  }

  @override
  void onEvalDataFetchFailure() {
    throw new UnimplementedError('onEvalDataFetchFailure');
  }
}
