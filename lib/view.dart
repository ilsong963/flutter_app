import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'ItemBox.dart';

class ViewRoute extends StatelessWidget {
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
  Database itemboxDB;
  List<ItemBox> itemboxList = [
    ItemBox(
      id: 1,
      name: 'apple',
      price: 1000,
    )
  ];

  @override
  initState() {
    super.initState();
    _openDatabase();
  }

  Future<void> _openDatabase() async {
    final path = join(await getDatabasesPath(), 'itembox.db');
    await deleteDatabase(path);
    itemboxDB = await openDatabase(path, onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE itembox(id INTEGER PRIMARY KEY, name TEXT, price INTEGER)");
    }, version: 1);
    _insertMember(itemboxList[0]);
  }

  Future<List<ItemBox>> _getMember() async {
    final List<Map<String, dynamic>> maps = await itemboxDB?.query('itembox');
    return List.generate(maps.length, (i) {
      return ItemBox(
        id: maps[i]['id'],
        name: maps[i]['name'],
        price: maps[i]['price'],
      );
    });
  }

  Future<void> _insertMember(ItemBox itembox) async {
    await itemboxDB?.insert(
      'members',
      itembox.toMap(),
    );
  }

  Future<void> _updateMember(ItemBox itembox) async {
    await itemboxDB?.update(
      'members',
      itembox.toMap(),
      where: 'id = ?',
      whereArgs: [itembox.id],
    );
  }

  Future<void> _deleteMember(int id) async {
    itemboxDB?.delete(
      'members',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final addItemController_name = TextEditingController();
  final addItemController_price = TextEditingController();

  bool _ischecked = false;
  List<ItemBox> boxList = <ItemBox>[];
  int index = 0;

  void addItemToList(String name, int price) {
    setState(() {
      boxList.insert(boxList.length, new ItemBox());
    });
  }

  void addItem(Context context) {
    showDialog(
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
                    Navigator.pop(context);
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
      onChanged: (bool value) {
        setState(() {
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
            addItem(context);
          },
          child: new Text(
            "ADD",
            style: new TextStyle(color: Colors.redAccent),
          ))
    ]);
  }

  void deleteItem() {
    setState(() {
    });
  }
}
