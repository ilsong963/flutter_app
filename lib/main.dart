import 'package:flutter/material.dart';

import 'package:flutter_app/route_generator.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/start.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Start(),
      onGenerateRoute: RouteGenerater.generateRoute,
      builder: (context, child) {
        return MediaQuery(
          child: child,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
    );
  }
}