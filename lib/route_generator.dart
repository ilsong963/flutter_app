import 'package:flutter/material.dart';
import 'package:flutter_app/start.dart';
import 'package:flutter_app/view.dart';

import 'constants.dart';

class RouteGenerater {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return MaterialPageRoute(
            builder: (_) => Start());
      case viewRoute:
        return MaterialPageRoute(
            builder: (_) => ViewRoute());
      default:
        return MaterialPageRoute(
           // settings: settings, builder: (_) => ErrorView();
        );
    }
  }
}