
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'db_help.dart';
import 'ItemBox.dart';

class ViewRoute extends StatelessWidget {
  static const String _title = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
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

  final addItemController_name = TextEditingController();
  final addItemController_price = TextEditingController();

  bool _ischecked = false;
  List<ItemBox> boxList = <ItemBox>[];
  int index = 0;

  void addItemToList(String name, int price) {

    ItemBox itembox = ItemBox(name: name,price: price);
    setState(() {
      boxList.insert(boxList.length,itembox);
    });
    DBHelper().createData(itembox);
  }

  void addItem(Context context) {

    showDialog(
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
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
    return Scaffold(
        appBar: AppBar(
        ),
        body: FutureBuilder(
          future: DBHelper().getAllItemBoxs(),
          builder: (BuildContext context, AsyncSnapshot<List<ItemBox>> snapshot) {
            if(snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  ItemBox item = snapshot.data[index];
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      DBHelper().deleteItem(item.id);
                      setState(() {});
                    },
                    child: Center(child: Text(item.name)),
                  );
                },
              );
            }
            else
            {
              return Center(child: CircularProgressIndicator(),);
            }
          },
        ),


    );
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
      ,
    ]);
  }

  void deleteItem() {
    DBHelper().deleteAllItemBoxs();
    setState(() {});
  }
}
