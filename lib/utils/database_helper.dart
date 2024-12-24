// Veritabanı Yönetimi

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');

    return await openDatabase(
      path,
      version: 2, // Veritabanı sürümünü 2'ye çıkardık
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Upgrade işlemi için metodu ekledik
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        isCompleted INTEGER,
        priority TEXT DEFAULT 'Düşük',
       

      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Görev önceliği sütunu ekleniyor
      await db.execute(
          "ALTER TABLE tasks ADD COLUMN priority TEXT DEFAULT 'Düşük'");
      
    }
  }

  //Görev ekleme metodunu güncelle
  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert('tasks', {
      'title': task.title,
      'description': task.description,
      'isCompleted': task.isCompleted ? 1 : 0,
      'priority': task.priority ?? 'Düşük',
    });
  }

  // Görevleri çekme metodunu güncelle
  Future<List<Task>> getTasks() async {
    final db = await database;
    final maps = await db.query(
      'tasks',
      orderBy: 'priority DESC',
    );

    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'] as int,
        title: maps[i]['title'] as String,
        description: maps[i]['description'] as String,
        isCompleted: maps[i]['isCompleted'] == 1,
        priority: maps[i]['priority'] as String? ?? 'Düşük',
      );
    });
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
