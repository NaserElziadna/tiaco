import 'dart:io';
import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:tictactoe/src/models/game_stat.dart';
import 'package:path_provider/path_provider.dart';

class DBService {
  static Database? _database;
  static const String DATABASE_NAME = 'tic_tac_toe.db',
      TABLE = 'stats',
      WINS = 'wins',
      LOSSES = 'losses',
      DRAWS = 'draws',
      DATA = 'data';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      return await initDb();
    }
  }

  Future<Database> initDb() async {
    String tempPath = (await getApplicationDocumentsDirectory()).path;

    String path = File('$tempPath/$DATABASE_NAME').path;
    return await openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute(
          'CREATE TABLE $TABLE ($DATA TEXT PRIMARY KEY UNIQUE, $WINS INTEGER, $LOSSES INTEGER, $DRAWS INTEGER)');
    });
  }

  Future<List<GameStat>> getStats() async {
    Database dbClient = await database;
    List<Map<String, dynamic>> maps =
        await dbClient.rawQuery('SELECT * FROM $TABLE');
    if (maps.length > 0) {
      return maps.map((data) => GameStat.fromMap(data)).toList();
    } else {
      return [];
    }
  }

  Future<int> insert(GameStat gameStat) async {
    Database dbClient = await database;
    return await dbClient.insert(TABLE, gameStat.toMap());
  }

  Future<int> update(GameStat gameStat) async {
    Database dbClient = await database;
    return await dbClient.update(TABLE, gameStat.toMap(),
        where: '$DATA = ?', whereArgs: [gameStat.data]);
  }
}