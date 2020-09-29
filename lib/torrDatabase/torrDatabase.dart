import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

final String _tableName = 'bookmarks';
final String colId = '_id';
final String colTitle = 'title';
final String colMagnetLink = 'magnetLink';
final String colDate = 'date';
final String colSize = 'size';
final String colSeeds = 'seeds';
final String colLeechs = 'leechs';

class TorrentDatabase {
  static final _databaseName = 'Data.db';

  static final _databaseVersion = 1;

  TorrentDatabase._privateConstructor();
  static final TorrentDatabase instance = TorrentDatabase._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase(); //if database does not exit, create one
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $_tableName (
    $colId INTEGER PRIMARY KEY,
    $colTitle TEXT UNIQUE,
    $colMagnetLink TEXT NOT NULL,
    $colDate TEXT NOT NULL,
    $colSize TEXT NOT NULL,
    $colSeeds TEXT NOT NULL,
    $colLeechs TEXT NOT NULL
    )
    ''');
  }

  Future<int> insert(Torrent torrent) async {
    Database db = await database;
    int id = await db.insert(_tableName, torrent.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  Future<Torrent> quesryTorrent(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(_tableName,
        columns: [
          colId,
          colTitle,
          colMagnetLink,
          colDate,
          colSize,
          colSeeds,
          colLeechs
        ],
        where: '$colId = ?',
        whereArgs: [id]);

    if (maps.length > 0) {
      return Torrent.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> torrents() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List.generate(maps.length, (i) {
      return Torrent(
        id: maps[i][colId],
        title: maps[i][colTitle],
        magnetLink: maps[i][colMagnetLink],
        date: maps[i][colDate],
        size: maps[i][colSize],
        seeds: maps[i][colSeeds],
        leechs: maps[i][colLeechs],
      ).toMap();
    });
  }

  Future<List> bookmarkedList() async {
    final Database db = await database;
    var results = await db.rawQuery("SELECT $colTitle FROM $_tableName");
    return(results);
  }

  Future<void> deleteTorrent(String title) async {
    final db = await database;
    await db.delete(_tableName, where: '$colTitle = ?', whereArgs: [title]);
  }
}

class Torrent {
  int id;
  String title;
  String magnetLink;
  String date;
  String size;
  String seeds;
  String leechs;

  Torrent(
      {this.id,
      this.title,
      this.magnetLink,
      this.date,
      this.size,
      this.seeds,
      this.leechs});

  Torrent.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    title = map[colTitle];
    magnetLink = map[colMagnetLink];
    date = map[colDate];
    size = map[colSize];
    seeds = map[colSeeds];
    leechs = map[colLeechs];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colTitle: title,
      colMagnetLink: magnetLink,
      colDate: date,
      colSize: size,
      colSeeds: seeds,
      colLeechs: leechs
    };
    if (id != null) {
      map[colId] = id;
    }
    return map;
  }
}
