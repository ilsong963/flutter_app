import 'package:firebase_messaging/firebase_messaging.dart';
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

class ItemBox {
  String name;
  int price;
  bool ischecked = false;

  ItemBox(String name, int price) {
    this.name = name;
    this.price = price;
  }
}

class _UpdateText extends State<UpdateText> {
  int listindex = 0;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final addItemController_name = TextEditingController();
  final addItemController_price = TextEditingController();

  bool _ischecked = false;
  List<ItemBox> boxList = <ItemBox>[];
  int index = 0;

  void addItemToList(String name, int price) {
    setState(() {
      boxList.insert(listindex, new ItemBox(name, price));
      listindex = boxList.length;
    });
    Navigator.pop(context);
  }

  void addItem() {
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
                  controller: addItemController_name,
                ),
                TextField(
                  controller: addItemController_price,
                ),
              ],
            ),
            actions: <Widget>[

              new FlatButton(
                  child: Text("취소"),
                  onPressed: () {
                    resetController();
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: Text("확인"),
                  onPressed: () {
                    addItemToList(addItemController_name.text,
                        int.parse(addItemController_price.text));
                    resetController();
                  }),
            ],
          );
        });
  }

  void resetController() {
    addItemController_name.text = "";
    addItemController_price.text = "";
  }

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print('token :$token');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: boxList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 60,
            child: Center(child: boxItem(index)),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      )),
      btnWidget(),
    ]);
  }

  Widget boxItem(int index) {
    return CheckboxListTile(
      title: Text("상품"),
      subtitle: itemContent(boxList[index].name, boxList[index].price),
      value: boxList[index].ischecked,
      onChanged: (bool value) {
        setState(() {
          boxList[index].ischecked = value;
        });
      },
      secondary: const Icon(Icons.home),
      activeColor: Colors.red,
      checkColor: Colors.black,
      isThreeLine: false,
      selected: _ischecked,
    );
  }

  Widget itemContent(String name, int price) {
    return Text("이름 : " + '$name' + "   가격 : " + '$price');
  }

  Widget btnWidget() {
    return Row(children: [
      FlatButton(
          onPressed: () {
            deleteItem();
          },
          child: new Text(
            "DELET",
            style: new TextStyle(color: Colors.redAccent),
          )),
      FlatButton(
          onPressed: () {
            addItem();
          },
          child: new Text(
            "ADD",
            style: new TextStyle(color: Colors.redAccent),
          ))
    ]);
  }

  void deleteItem() {
    setState(() {
      for (int i = boxList.length-1; i >0; i--) {
        if (boxList[i].ischecked == true) {
          boxList.removeAt(i);
        }
      }
      listindex = boxList.length;
    });
  }
}
