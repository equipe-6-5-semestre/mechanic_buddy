import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../src/pages/mechanics/mechanic.dart';
import '../src/pages/users/user.dart';

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
    String path = join(await getDatabasesPath(), 'mechanics.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE mechanics(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        phone TEXT,
        specialization TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        password TEXT
      )
    ''');
  }

  Future<int> insertMechanic(Mechanic mechanic) async {
    Database db = await database;
    return await db.insert('mechanics', mechanic.toMap());
  }

  Future<List<Mechanic>> getMechanics() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('mechanics');
    return List.generate(maps.length, (i) {
      return Mechanic.fromMap(maps[i]);
    });
  }

  Future<int> updateMechanic(Mechanic mechanic) async {
    Database db = await database;
    return await db.update(
      'mechanics',
      mechanic.toMap(),
      where: 'id = ?',
      whereArgs: [mechanic.id],
    );
  }

  Future<int> deleteMechanic(int id) async {
    Database db = await database;
    return await db.delete(
      'mechanics',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// Methods for users
  Future<int> insertUser(User user) async {
    Database db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUser(String username, String password) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }
}
