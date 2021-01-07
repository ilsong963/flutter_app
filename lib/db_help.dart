import 'dart:io';

import 'package:flutter_app/ItemBox.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final String TableName = 'Itembox';

class DBHelper {

  DBHelper._();
  static final DBHelper _db = DBHelper._();
  factory DBHelper() => _db;

  static Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'MyItemBoxDB.db');

    return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE $TableName(
            id INTEGER PRIMARY KEY,
            name TEXT,
            price INTEGER,
          )
        ''');
        },
        onUpgrade: (db, oldVersion, newVersion){}
    );
  }

  //Create
  createData(ItemBox itembox) async {
    final db = await database;
    var res = await db.rawInsert('INSERT INTO $TableName(name) VALUES(?)', [itembox.name]);
    return res;
  }

  //Read
  getItem(int id) async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $TableName WHERE id = ?', [id]);
    return res.isNotEmpty ? ItemBox(id: res.first['id'], name: res.first['name']) : Null;
  }

  //Read All
  Future<List<ItemBox>> getAllItemBoxs() async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $TableName');
    List<ItemBox> list = res.isNotEmpty ? res.map((c) => ItemBox(id:c['id'], name:c['name'])).toList() : [];
    return list;
  }

  //Delete
  deleteItem(int id) async {
    final db = await database;
    var res = db.rawDelete('DELETE FROM $TableName WHERE id = ?', [id]);
    return res;
  }

  //Delete All
  deleteAllItemBoxs() async {
    final db = await database;
    db.rawDelete('DELETE FROM $TableName');
  }

}