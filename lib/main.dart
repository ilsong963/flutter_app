import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String _title = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: Center(
          child: UpdateText(),
        ),
      ),
    );
  }
}

class UpdateText extends StatefulWidget {
  UpdateText({Key key}) : super(key: key);

  @override
  _UpdateText createState() => _UpdateText();
}

class _UpdateText extends State<UpdateText> {
  bool _ischecked = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(child: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 60,
            child: Center(child: boxItem()),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      )),
      btnWidget(),
    ]);
  }

  Widget boxItem() {
    return CheckboxListTile(
      title: Text("상품"),
      subtitle: infoBox("1"),
      value: _ischecked,
      onChanged: (bool value) {
        setState(() {
          _ischecked = value;
        });
      },
      secondary: const Icon(Icons.home),
      activeColor: Colors.red,
      checkColor: Colors.black,
      isThreeLine: false,
      selected: _ischecked,
    );
  }

  Widget infoBox(String str) {
    String name = str;
    String price = str;
    return Text("이름 : " + '$name' + "   가격 : " + '$price');
  }
}

Widget btnWidget() {
  return Row(children: [
    FlatButton(
        child: new Text(
          "DELET",
          style: new TextStyle(color: Colors.redAccent),
        )),
    FlatButton(
        child: new Text(
          "EDIT",
          style: new TextStyle(color: Colors.redAccent),
        ))
  ]);
}

class CheckBoxListTileModel {
  String name;
  int price;
}