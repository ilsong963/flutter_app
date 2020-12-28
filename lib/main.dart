import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: Center(child: UpdateText())));
  }
}

class UpdateText extends StatefulWidget {
  UpdateTextState createState() => UpdateTextState();
}

class UpdateTextState extends State {
  String textHolder = 'Old Sample Text...!!!';
  final myController = TextEditingController();

  changeText(String str) {
    setState(() {
      textHolder = str;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Dialog'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('$textHolder'),
            Padding(padding: EdgeInsets.only(top: 40.0)),
            RaisedButton(
              child: Text(
                'Dialog Open',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                ),
              ),
              onPressed: () => FlutterDialog(),
            )
          ],
        ),
      ),
    );
  }

  void FlutterDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: <Widget>[
                new Text("Dialog Title"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: myController,
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text("확인"),
                onPressed: () => changeText(myController.text),
              ),
            ],
          );
        });
  }
}
