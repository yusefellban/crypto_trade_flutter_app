import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../data/models/coin_model.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'crypto_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        password TEXT
      )
    ''');

    // Wallet table
    await db.execute('''
      CREATE TABLE wallet(
        id TEXT PRIMARY KEY,
        symbol TEXT,
        name TEXT,
        image TEXT,
        current_price REAL,
        price_change_percentage_24h REAL
      )
    ''');
  }

  // Auth methods
  Future<int> registerUser(String name, String email, String password) async {
    final db = await database;
    return await db.insert('users', {
      'name': name,
      'email': email,
      'password': password,
    });
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  // Wallet methods
  Future<int> addCoinToWallet(CoinModel coin) async {
    final db = await database;
    return await db.insert(
      'wallet',
      {
        'id': coin.id,
        'symbol': coin.symbol,
        'name': coin.name,
        'image': coin.image,
        'current_price': coin.currentPrice,
        'price_change_percentage_24h': coin.priceChangePercentage24h,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> removeCoinFromWallet(String id) async {
    final db = await database;
    return await db.delete(
      'wallet',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getWalletCoins() async {
    final db = await database;
    return await db.query('wallet');
  }

  Future<bool> isCoinInWallet(String id) async {
    final db = await database;
    final result = await db.query(
      'wallet',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }
}
