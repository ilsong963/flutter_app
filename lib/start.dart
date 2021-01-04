import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Start extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Screen'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Launch screen'),
          onPressed: () {
            Navigator.pushNamed(context, '/view');
          },
        ),
      ),
    );
  }
}