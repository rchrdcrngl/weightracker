
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:WeightTracker/components/WeightData.dart';
import 'dart:io';
import 'dart:async';
import 'package:sqflite/sqflite.dart';


class WeightDBHelper{
  final String tblName = "WEIGHTDATA";

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path,"weight.db");
    return await openDatabase(
        path,
        version: 1,
        onCreate: (Database db,int version) async{
          await db.execute("""
          CREATE TABLE $tblName(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          weight REAL,
          date DATETIME)"""
          );
        });
  }

  Future<void> clearData() async{
    final db = await init();
    db.execute("""
          DROP TABLE $tblName""");
    return db.execute("""
          CREATE TABLE $tblName(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          weight REAL,
          date DATETIME)""");
  }


  Future<int> addWeight(WeightData data) async{
    final db = await init();
    return db.insert(tblName, data.toMap(),
    conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<WeightData> fetchPeakWeight() async{
    final db = await init();
    final maps = await db.query(tblName, orderBy: 'weight DESC', limit: 1);
    if (maps.isEmpty) return WeightData();
    return WeightData.fromMap(maps.first);
  }

  Future<WeightData> fetchTroughWeight() async{
    final db = await init();
    final maps = await db.query(tblName, orderBy: 'weight ASC', limit: 1);
    if (maps.isEmpty) return WeightData();
    return WeightData.fromMap(maps.first);
  }

  Future<WeightData> fetchLatestWeight() async{
    final db = await init();
    final maps = await db.query(tblName, orderBy: 'date DESC', limit: 1);
    if (maps.isEmpty) return WeightData();
    return WeightData.fromMap(maps.first);
  }

  Future<List<WeightData>> fetchAllWeights() async{
    final db = await init();
    final maps = await db.query(tblName, orderBy: 'date DESC');

    return List.generate(maps.length, (i) {
      return WeightData.fromMap(maps[i]);
    });
  }

  Future<List<WeightData>> fetchWeekWeights() async{
    final db = await init();
    final maps = await db.query(tblName, orderBy: 'date DESC', limit: 7);
    return List.generate(maps.length, (i) {
      return WeightData.fromMap(maps[i]);
    });
  }

  Future<int> deleteWeight(int id) async{
    final db = await init();

    int result = await db.delete(
        tblName, //table name
        where: "id = ?",
        whereArgs: [id]
    );
    return result;
  }

  Future<int> updateWeight(int id, WeightData item) async{
    final db = await init();
    int result = await db.update(
        tblName,
        item.toUpdateMap(),
        where: "id = ?",
        whereArgs: [id]
    );
    return result;
  }
}