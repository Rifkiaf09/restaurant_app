import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/restaurant_models.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static const String _tableFavorite = 'favorites';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'restaurant.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableFavorite (
            id TEXT PRIMARY KEY,
            name TEXT,
            city TEXT,
            pictureId TEXT,
            rating REAL,
            payload TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertFavorite(Map<String, dynamic> data) async {
    final db = await database;
    final toInsert = {
      'id': data['id'],
      'name': data['name'],
      'city': data['city'],
      'pictureId': data['pictureId'],
      'rating': (data['rating'] is num)
          ? (data['rating'] as num).toDouble()
          : 0.0,
      'payload': data['payload'] ?? jsonEncode(data),
    };
    return await db.insert(
      _tableFavorite,
      toInsert,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> removeFavorite(String id) async {
    final db = await database;
    return await db.delete(_tableFavorite, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<RestaurantSummary>> getFavorites() async {
    final db = await database;
    final result = await db.query(_tableFavorite);
    return result.map((e) {
      if (e['payload'] != null) {
        try {
          final Map<String, dynamic> json = jsonDecode(e['payload'] as String);
          return RestaurantSummary.fromJson(json);
        } catch (_) {}
      }
      return RestaurantSummary.fromJson({
        'id': e['id'],
        'name': e['name'],
        'description': '',
        'pictureId': e['pictureId'],
        'city': e['city'],
        'rating': e['rating'],
      });
    }).toList();
  }

  Future<bool> isFavorite(String id) async {
    final db = await database;
    final res = await db.query(
      _tableFavorite,
      where: 'id = ?',
      whereArgs: [id],
    );
    return res.isNotEmpty;
  }
}
