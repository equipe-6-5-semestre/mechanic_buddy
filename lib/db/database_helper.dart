import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../src/pages/mechanics/mechanic.dart';
import '../src/pages/users/user.dart';
import '../src/pages/mechanic_services/service.dart';

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
      version: 4,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        password TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE mechanics(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        phone TEXT,
        specialization TEXT,
        vehicle_types TEXT,
        experience INTEGER,
        city TEXT,
        user_id INTEGER,
        FOREIGN KEY(user_id) REFERENCES users(id)
      )
    ''');
    await db.execute('''
      CREATE TABLE services(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mechanic_id INTEGER,
        name TEXT,
        description TEXT,
        price REAL,
        FOREIGN KEY(mechanic_id) REFERENCES mechanics(id)
      )
    ''');
  }

  // Methods for mechanics
  Future<int> insertMechanic(Mechanic mechanic) async {
    Database db = await database;
    return await db.insert('mechanics', mechanic.toMap());
  }

  Future<List<Mechanic>> getMechanics(int userId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'mechanics',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return Mechanic.fromMap(maps[i]);
    });
  }

  Future<List<Mechanic>> getAllMechanics() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('mechanics');
    return List.generate(maps.length, (i) {
      return Mechanic.fromMap(maps[i]);
    });
  }

  Future<List<Mechanic>> getMechanicsByVehicleType(int userId, String vehicleType) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'mechanics',
      where: 'user_id = ? AND vehicle_types LIKE ?',
      whereArgs: [userId, '%$vehicleType%'],
    );
    return List.generate(maps.length, (i) {
      return Mechanic.fromMap(maps[i]);
    });
  }

  Future<Mechanic?> getUserMechanic(int userId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'mechanics',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    if (maps.isNotEmpty) {
      return Mechanic.fromMap(maps.first);
    }
    return null;
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

  // Methods for services
  Future<int> insertService(Service service) async {
    Database db = await database;
    return await db.insert('services', service.toMap());
  }

  Future<List<Service>> getServices(int mechanicId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'services',
      where: 'mechanic_id = ?',
      whereArgs: [mechanicId],
    );
    return List.generate(maps.length, (i) {
      return Service.fromMap(maps[i]);
    });
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

  Future<User?> getUserById(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }
}
