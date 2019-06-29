import 'package:flutter/material.dart';

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
            min: 0,
            max: 10,
            divisions: 10,
            value: _progress,
            onChanged: (value) {
              setState(() => _progress = value);
            },
          ),
          Text(_progress.toInt().toString())
        ],
      ),
    );
  }
}

class EvaluateView extends StatefulWidget {
  @override
  EvaluateViewState createState() => EvaluateViewState();
}

class EvaluateViewState extends State<EvaluateView> {
  var _params = <String>[
    'partnership',
    'joint',
    'responsibility',
    'kindness',
    'trust',
    'anger',
    'irritability',
    'compliance',
    'sociopathy',
    'isolation',
  ];

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
                    children: <Widget>[EvaluateWidget(_params[index])],
                  );
                }))
      ],
    ));
  }
}
