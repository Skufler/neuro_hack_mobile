import 'package:flutter/material.dart';
import 'package:neuro_hack/view/main_view.dart';

import 'constants.dart';
import 'dependency_injection.dart';

void main() {
  Injector.configure(Flavor.mock);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Constants.primary,
      ),
      home: MainView(),
    );
  }
}
