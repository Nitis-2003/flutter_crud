import 'package:flutter_crud/person.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Dbhelper {
  Dbhelper._instance();
  static final Dbhelper instance = Dbhelper._instance();
  static Database? _database;

  Future<Database> get db async {
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'emp.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE employees(id INTEGER PRIMARY KEY,name TEXT,department TEXT)',
    );
  }

  Future<int> insertEmp(Person emp) async {
    Database db = await instance.db;
    return await db.insert(
      'employees',
      emp.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.db;
    return await db.query('employees');
  }

  Future<void> deleteEmp(int id) async {
    Database db = await instance.db;
    await db.delete('employees', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateEmp(Person emp) async {
    Database db = await instance.db;
    await db.update(
      'employees',
      emp.toMap(),
      where: 'id = ?', 
      whereArgs: [emp.id]);
  }
}
